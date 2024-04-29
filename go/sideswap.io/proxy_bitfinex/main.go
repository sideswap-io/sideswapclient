package main

import "C"

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"log"
	"math"
	"net/http"
	"strconv"
	"time"

	"github.com/bitfinexcom/bitfinex-api-go/pkg/models/balanceinfo"
	"github.com/bitfinexcom/bitfinex-api-go/pkg/models/book"
	"github.com/bitfinexcom/bitfinex-api-go/pkg/models/common"
	"github.com/bitfinexcom/bitfinex-api-go/pkg/models/order"
	"github.com/bitfinexcom/bitfinex-api-go/pkg/models/wallet"
	"github.com/bitfinexcom/bitfinex-api-go/v2/websocket"
	gws "github.com/gorilla/websocket"
	"github.com/op/go-logging"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"
	"gopkg.in/natefinch/lumberjack.v2"
	myProto "sideswap.io/proxy_bitfinex/proto"
)

var flagPort = flag.Uint("port", 4101, "web-socket listen port on loopback interface")
var logFilePort = flag.String("logfile", "log.txt", "log file path")

const orderTypeMarket = "EXCHANGE MARKET"

var upgrader = gws.Upgrader{} // use default options

var jsonMarshalOption = protojson.MarshalOptions{
	UseProtoNames: true,
}

var jsonUnmarhalOption = protojson.UnmarshalOptions{}

type Data struct {
	log *logging.Logger
}

type convertor interface {
	recvMsg(messageType int, data []byte) (*myProto.To, error)
	sendMsg(from *myProto.From) (int, []byte)
}

type jsonConvertor struct{}

type protoConvertor struct{}

var errExpectingBinaryMessage = errors.New("expecting binary message")
var errExpectingTextMessage = errors.New("expecting text message")

func (m jsonConvertor) recvMsg(messageType int, data []byte) (*myProto.To, error) {
	if messageType != gws.TextMessage {
		return nil, errExpectingTextMessage
	}
	to := myProto.To{}
	err := jsonUnmarhalOption.Unmarshal(data, &to)
	if err != nil {
		return nil, err
	}
	return &to, nil
}

func check(err error) {
	if err != nil {
		log.Fatalf("unexpected error: %v", err)
	}
}

func (m jsonConvertor) sendMsg(from *myProto.From) (int, []byte) {
	d, err := jsonMarshalOption.Marshal(from)
	check(err)
	return gws.TextMessage, d
}

type MyEpochNonceGenerator struct {
	log *logging.Logger
}

func (u *MyEpochNonceGenerator) GetNonce() string {
	microseconds := time.Now().UnixNano() / 1000
	nonce := strconv.FormatInt(microseconds, 10)
	u.log.Infof("new nonce: %v", nonce)
	return nonce
}

func (m protoConvertor) recvMsg(messageType int, data []byte) (*myProto.To, error) {
	if messageType != gws.BinaryMessage {
		return nil, errExpectingBinaryMessage
	}
	to := myProto.To{}
	err := proto.Unmarshal(data, &to)
	if err != nil {
		return nil, err
	}
	return &to, nil
}

func (m protoConvertor) sendMsg(from *myProto.From) (int, []byte) {
	d, err := proto.Marshal(from)
	check(err)
	return gws.BinaryMessage, d
}

func sendMessage(d *Data, c *gws.Conn, conv convertor, from *myProto.From) error {
	mt, message := conv.sendMsg(from)

	err := c.WriteMessage(mt, message)
	if err != nil {
		d.log.Errorf("write failed: %v\n", err)
		return err
	}
	return nil
}

func sendError(d *Data, c *gws.Conn, conv convertor, errString string) error {
	d.log.Errorf("%s", errString)

	m := myProto.From{
		Msg: &myProto.From_Error{
			Error: &myProto.Error{
				Error: &errString,
			},
		},
	}

	err := sendMessage(d, c, conv, &m)

	return err
}

type clientMessage struct {
	data []byte
	mt   int
	err  error
}

type bookData struct {
	askLast float64
	bidLast float64
}

func handler(d *Data, conv convertor) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {

		var trader *websocket.Client

		traderParams := websocket.NewDefaultParameters()
		traderParams.Logger = d.log
		traderParams.ReconnectAttempts = math.MaxInt64
		traderParams.ManageOrderbook = true

		client, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			d.log.Infof("upgrade failed:", err)
			return
		}

		addr := client.RemoteAddr().String()
		d.log.Infof("client %s added", addr)

		defer func() {
			d.log.Infof("client %s removed", addr)
			client.Close()
		}()

		queue := make(chan clientMessage)
		responses := make(chan *myProto.From)
		traderChan := make(chan interface{})

		go func() {
			for {
				mt, data, err := client.ReadMessage()
				queue <- clientMessage{
					data: data,
					err:  err,
					mt:   mt,
				}
				if err != nil {
					return
				}
			}
		}()

		var ctx context.Context

		books := map[string]bookData{}

		for {
			select {
			case resp := <-responses:
				err = sendMessage(d, client, conv, resp)
				if err != nil {
					return
				}

			case request := <-queue:
				if request.err != nil {
					d.log.Errorf("read failed: %v", err)
					return
				}
				to, err := conv.recvMsg(request.mt, request.data)
				if err != nil {
					sendError(d, client, conv, fmt.Sprintf("convert failed: %v", err))
					continue
				}

				d.log.Debugf("request: %v", to)

				switch x := to.Msg.(type) {
				case *myProto.To_Login_:
					if trader != nil {
						sendError(d, client, conv, "must be not logged in")
						return
					}

					nonceGen := MyEpochNonceGenerator{
						log: d.log,
					}
					trader = websocket.NewWithParamsNonce(traderParams, &nonceGen).Credentials(x.Login.GetKey(), x.Login.GetSecret())

					err := trader.Connect()
					if err != nil {
						sendError(d, client, conv, fmt.Sprintf("connecting to bitfinex failed: %v", err))
						return
					}

					var cxl2 context.CancelFunc
					ctx, cxl2 = context.WithTimeout(context.Background(), time.Second*5)
					defer cxl2()

					go func() {
						for ch := range trader.Listen() {
							traderChan <- ch
						}
					}()

					defer func() {
						trader.Close()
					}()

				case *myProto.To_OrderSubmit_:
					break

				case *myProto.To_Movements_:
					break

				case *myProto.To_Subscribe_:
					if trader == nil {
						sendError(d, client, conv, "must be logged in")
						return
					}

					d.log.Infof("subscribe to new book %s", x.Subscribe.GetBookName())
					bookName := *x.Subscribe.BookName
					_, err = trader.SubscribeBook(ctx, bookName, common.Precision0, common.FrequencyRealtime, 25)
					if err != nil {
						sendError(d, client, conv, fmt.Sprintf("subscribing to book failed: %v", err))
						return
					}
					books[bookName] = bookData{}

				case *myProto.To_Withdraw_:
					d.log.Infof("ignore withdraw request...")

				case *myProto.To_Transfer_:
					d.log.Infof("ignore transfer request...")

				case nil:
					sendError(d, client, conv, "empty request, msg must be set")

				default:
					sendError(d, client, conv, fmt.Sprintf("unexpected type %T", x))
					return
				}

			case obj := <-traderChan:
				switch v := obj.(type) {
				case error:
					sendError(d, client, conv, fmt.Sprintf("bitfinex channel closed: %s", obj))
					return

				case *balanceinfo.Update, *book.Book, *book.Snapshot:
					break

				case *order.Cancel:
					if v.Amount == 0 {
						order := myProto.From{
							Msg: &myProto.From_OrderConfirm_{
								OrderConfirm: &myProto.From_OrderConfirm{
									Cid:      &v.CID,
									Id:       &v.ID,
									Amount:   &v.AmountOrig,
									Price:    &v.PriceAvg,
									BookName: &v.Symbol,
								},
							},
						}
						err = sendMessage(d, client, conv, &order)
						if err != nil {
							return
						}
					}

				case *wallet.Update:
					wallet := myProto.From{
						Msg: &myProto.From_WalletUpdate_{
							WalletUpdate: &myProto.From_WalletUpdate{
								Currency: &v.Currency,
								Balance:  &v.Balance,
							},
						},
					}
					err = sendMessage(d, client, conv, &wallet)
					if err != nil {
						return
					}

				default:
					d.log.Debugf("bitfinex message: %T: %v\n", obj, obj)
				}

				for bookName := range books {
					ob, _ := trader.GetOrderbook(bookName)
					if ob != nil {
						asks := ob.Asks()
						bids := ob.Bids()
						if len(asks) > 0 && len(bids) > 0 {
							askNew := asks[0].Price
							bidNew := bids[0].Price
							for _, ask := range asks {
								if ask.Price < askNew {
									askNew = ask.Price
								}
							}
							for _, bid := range bids {
								if bid.Price > bidNew {
									bidNew = bid.Price
								}
							}
							bookData := books[bookName]
							if askNew != bookData.askLast || bidNew != bookData.bidLast {
								bookData.askLast = askNew
								bookData.bidLast = bidNew
								books[bookName] = bookData
								price := myProto.From{
									Msg: &myProto.From_BookUpdate_{
										BookUpdate: &myProto.From_BookUpdate{
											BookName: &bookName,
											Price: &myProto.Price{
												Ask: &askNew,
												Bid: &bidNew,
											},
										},
									},
								}
								err = sendMessage(d, client, conv, &price)
								if err != nil {
									return
								}
							}
						}
					}
				}
			}
		}
	}
}

func socketServer(port uint16, logFile string) {
	d := &Data{}
	d.log = initLogger(logFile)

	http.HandleFunc("/text", handler(d, &jsonConvertor{}))
	http.HandleFunc("/binary", handler(d, &protoConvertor{}))
	log.Fatal(http.ListenAndServe(fmt.Sprintf("localhost:%d", port), nil))
}

func initLogger(logFile string) *logging.Logger {
	var log = logging.MustGetLogger("sideswap_bitfinex")
	//backend := logging.NewLogBackend(os.Stderr, "", 0)
	backend := logging.NewLogBackend(&lumberjack.Logger{
		Filename:   logFile,
		MaxBackups: 10,
		Compress:   true,
	}, "", 0)
	backendFormatter := logging.NewBackendFormatter(backend, logging.GlogFormatter)
	logging.SetBackend(backendFormatter)
	logging.SetLevel(logging.INFO, "")
	return log
}

//export cgoStartApp
func cgoStartApp(port uint16, logFile *C.char) {
	socketServer(port, C.GoString(logFile))
}

func main() {
	flag.Parse()

	socketServer(uint16(*flagPort), *logFilePort)
}
