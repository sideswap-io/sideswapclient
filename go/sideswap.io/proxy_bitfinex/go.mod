module sideswap.io/proxy_bitfinex

go 1.14

require (
	github.com/bitfinexcom/bitfinex-api-go v0.0.0-20210101155619-bb56f756df78
	github.com/golang/protobuf v1.4.1
	github.com/gorilla/websocket v1.4.2
	github.com/op/go-logging v0.0.0-20160315200505-970db520ece7
	google.golang.org/protobuf v1.25.0
	gopkg.in/natefinch/lumberjack.v2 v2.0.0
)

replace github.com/bitfinexcom/bitfinex-api-go => ../../../thirdparty/bitfinex-api-go
