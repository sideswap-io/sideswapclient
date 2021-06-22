#!/usr/bin/env node

const WS_SECRET = "123"

const websocket = require('websocket').client;
const fetch = require('node-fetch');

var client = new websocket();
var connection = null;

function reconnect() {
    client.connect('ws://localhost:9002');
}

function reconnectTimer() {
    connection = null;
    setTimeout(reconnect, 10000);
}

function downloadPrice() {
    if (connection) {
        fetch('https://blockchain.info/ticker')
            .then(res => res.json())
            .then(json => {
                let price = json['USD']['last'];
                if (connection) {
                    const msg = JSON.stringify({
                        price: {
                            ticker: 'USDt',
                            price: {
                                bid: price,
                                ask: price,
                            },
                        }
                    });
                    console.log('send: ' + msg);
                    connection.sendUTF(msg);
                }
            })
            .catch((error) => {
                console.error('price download failed: ' + error);
            });
    }
    setTimeout(downloadPrice, 10000)
}

client.on('connectFailed', function (error) {
    console.log('connection failed: ' + error.toString());
    reconnectTimer();
});

client.on('connect', function (c) {
    console.log('connected');
    c.sendUTF(JSON.stringify({ authorize: WS_SECRET }));
    connection = c;

    c.on('error', function (error) {
        console.log("connection error: " + error.toString());
    });

    c.on('close', function () {
        console.log('connection closed');
        reconnectTimer();
    });

    c.on('message', function (message) {
        if (message.type === 'utf8') {
            console.log("recv: " + message.utf8Data);
        }
    });
});

setTimeout(downloadPrice, 1000)
reconnect();
