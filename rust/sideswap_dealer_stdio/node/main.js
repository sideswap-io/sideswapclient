#!/usr/bin/env node

const { spawn } = require('child_process');

const subprocess = spawn('/path/to/sideswap_dealer_stdio', ['/path/to/dealer_stdio_config.toml'])

subprocess.stdout.on('data', (data) => {
    // Process sucessful swaps
    // Example:
    // {"swap":{"txid":"1588f7f69b74d4e1b21a48af54b302f3492c702a822925cd82d6c7382a3091d4","ticker":"DePIX","bitcoin_amount":87139,"dealer_send_bitcoins":true}}
    console.log(`received: ${data}`);
});

// Make sure stderr output is processed, we don't want to block the subprocess
subprocess.stderr.on('data', (data) => {});

subprocess.on('close', (code) => {
  console.log(`child process exited with code ${code}`);
  process.exit(1)
});

function downloadPrice() {
    fetch('https://blockchain.info/ticker')
        .then(res => res.json())
        .then(json => {
            let price = json['BRL']['last'];
            const msg = JSON.stringify({
                price: {
                    ticker: 'dePIX',
                    price: {
                        submit_price: {
                            bid: price,
                            ask: price,
                        },
                        limit_btc_dealer_recv: 1.0,
                        limit_btc_dealer_send: 1.0,
                        balancing: false,
                    },
                }
            });
            console.log('send: ' + msg);
            subprocess.stdin.write(msg);
            subprocess.stdin.write("\n");
        })
        .catch((error) => {
            console.error('price download failed: ' + error);
        });
    setTimeout(downloadPrice, 10000)
}

setTimeout(downloadPrice, 2000)
