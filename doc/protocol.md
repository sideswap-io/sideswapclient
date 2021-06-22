# SideSwap swap protocol

TL;DR: SideSwap’s swap protocol is a working implementation for secure p2p swaps on the Liquid Network. It is designed to ensure the formation of orderly markets where (i) the party creating the offer may determine the terms of the trade, including time-to-live (ii) neither participant receives their counterparty’s signed UTXOs.

## Liquid Network

The Liquid Network is a side-chain to the bitcoin blockchain which supports asset issuance and Confidential Transactions. The native asset of the network is Liquid bitcoin (L-BTC), which are issued and redeemed in a 1:1 ratio for any bitcoin pegged to the Liquid sidechain. Issued assets are created by issuers seeking to find a market for their tokens or securities.

Given that the Liquid network supports the issuance of multiple assets, it becomes feasible (and desirable) to trade assets in atomic swaps between participants, ensuring trust-less trading without relying on custodian intermediaries.

## Atomic swaps

Liquid, like bitcoin, uses a UTXO model and its transaction structure is similar. The basic premise of an atomic swap is where two parties (Alica and Bob) agree to exchange one asset issued on the liquid network for another asset issued on the liquid network. The parties create a “joined” transaction where each party provides their input UTXOs (the assets they are offering), a receiving address, and a change address. Once both parties agree that the transaction structure is correct, they may sign for their own UTXOs and broadcast the atomic transaction.

## Other implementations

While the atomic swap transaction creation is straight forward, the game-theory mechanics to ensure a fair and orderly swap protocol requires trade-offs. The following models, including their pros and cons, currently exist:

Liquid Swap Tool (https://github.com/Blockstream/liquid-swap) is a three-step protocol where (1) Alice proposes a swap, including all inputs and outputs (2) Bob reviewing the proposal, adding his own inputs and outputs, signing his inputs, and returning the transaction to Alice (3) Alice proceeds to review Bobs inputs and outputs, signs her own inputs, and broadcasts the transaction.

The Liquid Swap Tool was created as a proof of concept implementation for demonstrating atomic swap functionality and was never implemented into an implementation intended for wider use. While such an implementation may be possible, the model suffers a few drawbacks, most notably that Alice may keep Bob’s signed transaction and broadcast it only when it is profitable to Alice. The only way Bob can invalidate the atomic swap is for him to spend the offered UTXOs in another transaction.

A second atomic swap implementation, LiquidDEX (https://leocomandini.github.io/2021/06/15/liquidex.html), proposes a two-step approach where the Makers (Alice) proposal includes a receiving amount and a single UTXO which is signed utilizing SIGHASH_SINGLE | SIGHASH_ANYONECANPAY. This allows the Taker (Bob) to add more inputs and outputs without invalidating the Maker signature.

LiquiDEX has a big benefit in that it only has two steps, which allows the Maker (Alice) to create the offer without having to be around to sign her inputs after the trade has been accepted by Bob. This model has many benefits and is ideal for multiple use-cases Including scenarios where Alice goes offline). The considerations of the model relate to (i) Alice having no way of withdrawing her offer without spending her UTXOs once she has shared her offer (ii) the model requiring the maker to always sell exactly one whole UTXO without any change (iii) an inability to update the swap price without re-submitting a signed order.

## SideSwap atomic swap protocol

SideSwap’s atomic swap implementation (http://sideswap.io/docs/), a third model, is a three-step model where the Maker and Taker rely on a central server to ensure (i) that offers may be time limited (ii) the swap price may be updated without submitting a new order (iii) Takers must provide valid input UTXOs (and other transaction details) prior to receiving the Makers unblinded transaction details (iv) neither party to the swap may receive the other party’s signed transaction half (users do not have to spend their UTXOs to cancel an offer). The trade-off is that both participants must be online in order to sign their respective halves.

The Maker (Alice) provides her input UTXOs (in PSET), a receiving address, receiving asset, a change address, time-to-live, and desired swap price. The server validates the input(s), starts monitoring for spentness, and creates an offer. The offer may be made available in our public order book or shared privately. The Taker (Bob), upon accepting the offer, is requested to provide the server with the same details as the Maker prior to the server creating the full atomic swap transaction using the two parties details (this means only eligible counterparties may view the Makers unblinded offer). The server then requests that the Taker validates the full transaction prior to signing for its inputs and returning its signed transaction half. The server thereafter sends the full unsigned transaction to the Maker (Alice) and asks her to validate and sign her transaction inputs. Once the server has the two signed transaction halves, it merges the two halves together and broadcasts the transaction.

## Improvement

The main drawback of the three-step model is the requirement placed on the Maker to both be online as well as being asked to sign for the transaction in a manner which is timely and fair on the Taker. SideSwap has implemented an auto-sign functionality where the UTXOs (PSET) offered may be automatically signed upon receipt of a signed offer which corresponds to the requested price and counter-quantity.
