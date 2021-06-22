#!/usr/bin/env python3

import time
import websocket
import threading
import json
import urllib.request

WS_SECRET = "123"


class PriceDownload(object):
    def __init__(self):
        self.price_callback = None

    def run(self):
        time.sleep(1)
        while True:
            if self.price_callback != None:
                try:
                    data = urllib.request.urlopen(
                        "https://blockchain.info/ticker").read().decode("utf-8")
                    data = json.loads(data)
                    # Use USD price as USDt
                    price = data["USD"]["last"]
                    if self.price_callback != None:
                        self.price_callback(price)
                except Exception as e:
                    print("price download failed: {}".format(e))

            time.sleep(10)


def main():
    price_downloader = PriceDownload()

    thread = threading.Thread(target=price_downloader.run)
    thread.daemon = True
    thread.start()

    while True:
        def on_open(wsapp):
            login_request = {
                "authorize": WS_SECRET
            }
            wsapp.send(json.dumps(login_request))

            def price_callback(price):
                # Dealer will apply interest to the prices so use bid and ask as-is
                to = {
                    "price": {
                        "ticker": "USDt",
                        "price": {
                            "bid": price,
                            "ask": price,
                        }
                    }
                }

                json_object = json.dumps(to)
                print("send: {}".format(json_object))
                wsapp.send(json_object)

            print("connected...")
            price_downloader.price_callback = price_callback

        def on_message(wsapp, message):
            print("recv: {}".format(message))

        def on_close(wsapp):
            print("closed...")

        wsapp = websocket.WebSocketApp(
            "ws://localhost:9002", on_message=on_message, on_open=on_open, on_close=on_close)

        wsapp.run_forever()
        price_downloader.price_callback = None
        time.sleep(10)


if __name__ == "__main__":
    main()
