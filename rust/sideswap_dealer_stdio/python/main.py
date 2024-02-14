#!/usr/bin/env python3

import threading
import subprocess
import requests
import time
import json

def handle_stdout(data):
    print(f"received: {data}")

def on_close(code):
    print(f"child process exited with code {code}")
    exit(1)

def download_price(dealer_process):
    try:
        response = requests.get('https://blockchain.info/ticker')
        data = response.json()
        price = data['BRL']['last']
        msg = json.dumps({
            "price": {
                "ticker": "dePIX",
                "price": {
                    "submit_price": {
                        "bid": price,
                        "ask": price,
                    },
                    "limit_btc_dealer_recv": 1.0,
                    "limit_btc_dealer_send": 1.0,
                    "balancing": False,
                }
            }
        })
        print('send: ' + msg)
        dealer_process.stdin.write(msg + "\n")
        dealer_process.stdin.flush()
    except Exception as error:
        print('price download failed: ' + str(error))

def download_price_loop(dealer_process):
    while True:
        download_price(dealer_process)
        time.sleep(10)

def main():
    subprocess_args = ['/path/to/sideswap_dealer_stdio', '/path/to/dealer_stdio_config.toml']
    dealer_process = subprocess.Popen(subprocess_args, stdout=subprocess.PIPE, stdin=subprocess.PIPE, text=True)

    my_thread = threading.Thread(target=download_price_loop, args=(dealer_process,))
    my_thread.start()

    while True:
        return_code = dealer_process.poll()
        if return_code is not None:
            on_close(return_code)
            break

        output = dealer_process.stdout.readline().strip()
        if output:
            handle_stdout(output)

if __name__ == "__main__":
    main()
