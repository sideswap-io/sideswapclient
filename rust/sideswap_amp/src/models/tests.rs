use super::*;

#[test]
fn test_authenticate_result() {
    // Blinded, confirmed
    let auth_result = r#" {
        "appearance": {
            "unit": "BTC",
            "replace_by_fee": true,
            "current_subaccount": 0,
            "use_segwit": true,
            "use_csv": true
        },
        "block_height": 1372525,
        "block_hash": "36250824a433cf464c2fc6c7b34a23d4244edf98596e24d03e5f85cba9b06719",
        "cache_password": "f4f1eb75-358c-4e87-8966-f3cf6bc3010309a7c9a5-f958-4056-b3ea-7440718e8483",
        "chain_code": "7923408dadd3c7b56eed15567707ae5e5dca089de972e07f3b860450e2a3b70e",
        "client_blob_hmac": "8U1B4wCNdEvBm4StCo58gt+WE7MI+SA6mQatzMiDJ1I=",
        "country": "",
        "csv_blocks": 65535,
        "currency": "USD",
        "dust": 1,
        "earliest_key_creation_time": 1714537053,
        "exchange": "BITSTAMP",
        "fee_estimates": {
            "1": {
            "feerate": 0.00000109,
            "blocks": 2
            },
            "2": {
            "feerate": 0.00000109,
            "blocks": 2
            },
            "3": {
            "feerate": 0.00000109,
            "blocks": 3
            },
            "6": {
            "feerate": 0.00000109,
            "blocks": 6
            },
            "12": {
            "feerate": 0.00000109,
            "blocks": 12
            },
            "24": {
            "feerate": 0.00000109,
            "blocks": 24
            }
        },
        "gait_path": "7f112a1838c8af4d4fea8a2c840ae7faa52b91a8650e040bd7d76c434d3b36243b3b34b1c4d9c0eadd406d1f32834e84a9c7d90adc811f21393e2deb8c587ed8",
        "has_txs": false,
        "min_fee": 100,
        "prev_block_hash": "99897971a8b38a39385fa88de5f1e94714122c011ca31c28182a0638395aa3bb",
        "public_key": "03d902f35f560e0470c63313c7369168d9d7df2d49bf295fd9fb7cb109ccee0494",
        "rbf": true,
        "receiving_id": "GA34bBrDR9jeLUhB3BxbPKDf9VEWGv",
        "segwit": false,
        "segwit_server": true,
        "csv_server": true,
        "csv_times": [
            1440,
            65535
        ],
        "subaccounts": [
            {
            "name": "",
            "pointer": 1,
            "receiving_id": "GA482kE99ryLtoSh43eBK8hUMtRCe6",
            "2of3_backup_chaincode": null,
            "2of3_backup_pubkey": null,
            "2of3_backup_xpub": null,
            "2of3_backup_xpub_sig": null,
            "type": "2of2_no_recovery",
            "has_txs": false,
            "required_ca": 0
            }
        ],
        "fiat_currency": "USD",
        "fiat_exchange": "45.06133133881825",
        "reset_2fa_active": false,
        "reset_2fa_days_remaining": -1,
        "reset_2fa_disputed": false,
        "nlocktime_blocks": 12960,
        "first_login": false,
        "privacy": {
            "send_me": 1,
            "show_as_sender": 1
        },
        "limits": {
            "total": 0,
            "per_tx": 0,
            "is_fiat": false
        }
    } "#;
    serde_json::from_str::<AuthenticateResult>(&auth_result).unwrap();
}

#[test]
fn test_utxo() {
    // Blinded, confirmed
    let utxo1 = r#" {
        "block_height": 1274750,
        "txhash": "b2c275ea25f12ae982c237387c93593177b38bb5457812105ef4256c1e2b09b4",
        "pt_idx": 1,
        "subaccount": 1,
        "pointer": 748,
        "script_type": 14,
        "user_status": 0,
        "value": null,
        "subtype": 0,
        "asset_tag": "0baa79d4abfc808c47eb8b3bb97e5ca7091f0cb4204d9c653b4f5cc5bc560cd234",
        "script": "a914d2eb77ed1c8be9dd587ae6a4287e311de5cc31ae87",
        "commitment": "086a72f3bed046c467ef9e5e94a73db5c7595ce52edb8be570573e786c688fc27b",
        "nonce_commitment": "030d71f6d219555cec3540e3666a2580017275d911c912cd5e0430c6ba1125085e",
        "surj_proof": "060031cfd8cff18a71b965be97a4012908560e0dbd48738a5ce7ce8487f02812a1b025aeaa15491df13a356ca5e97a51fb5d605832449beacd658b613a3e37da72a9f2e295083a5ebf7c12662f1637c81e1b91a45e28f03b5f3b49434f1ec7acd639e74e1f787a58a9f6bc63b7fa3fb84adffd16015dfe1f06b3fd909afb9df6918b67",
        "range_proof": "60330000000000000001c5122000471a81ce68b3940b1c986a44dec22a3e349308b9c5340658e9c905848bacec3510b03ba2e40792881eb500809b2c96ace83d79adbbde3f399ed1645565128c71d56a5399c9051a53c507e94a364dd76134e4b2ec440ce2bcd89c64f56ac9202a306fa29e07d7b4e70c19ed08073e7fe52bdb1ff3a65c652ba17454a458e22b9ffdb18ce3219e4580e4b9e9c82351a4a2d9f5ce5db7736e15b5aba138a87083eb1476ebff91ce79b302fb514520ae09639e0983a3d9f8535af8a20997f4d76bfe3ddce35cc220678f10b29f3373dbf777c67f098b23af26a9d86513f75f1d708ebd004b3bae3ceb92747dbba2aed9842761a8922b465a41eab394dd523e740b8b38c1fb3d8aa6c6a7a0484e0e9b8505e780a7fccc2eb1d95b523cc24c1a6065a91a9575d436be50fb5c08830d8f1fe30ec1f8fa06bd3bab677ab51e53c73329ee01622ca9dad0288a852c466d466fe1127bc0f87173d56b4267ecb31bc88a9143cc62329fa5217aadd129ccf4f203f1205bd50dddb8f9def568fd4911bed57b55716ca887af41aa0b59daf0f6af509f4e6c1dde35b1580e09212f5397128b7b09ef66608a58864c2776dbf4c4c2586aa881aeabdd29c386ee0dfa4520fa5d90689afc344281c395228822a8f072e0c5bda9a27643ae77303e2da0c4655d1e49ce1761576cefe679e8661f7b450e1680de68c6d99a6e9ba2cf97fb16499c31d9c0f9fe5cf24bcb05654c1bb4ff0ce7feb0aa1e63f628f860f99c7de023f189273e4a2a644fd4b2b45313201b02067fbe39a409c2cc5b67e41e9d9c461fc9bad1d8ce88cdda6b838c86aa44cdcbf79d9665129564caeb0375bf68b024d6a63b7f9397ab7ed01cfd510a5bc3d84d3698e27709b25514e1fa1fb2e301a48deea75c15371019740ad291073ffc677ea17e1881ee05e5bb9bb4631d5c861a7b517a607626a8cc0cca35983b9eca0713caa494cfc3463e63380b86b135fdcf4c30cf36b942fc5eacd1702c48bd13310fa5d8efaebb544d9f149c965ba0b8853b2dd8f213c8fe1d56f8f6e23e56b19e5270900e4733478337f4e41d8f1397ef8a8e6c06e2aa84f95c66ebff5b71f1f20daaafe5038178951fcb4f450c4a521dc5bff39e7a847d2b823cfc5fc87c0cad71b7c2720103d184f4f748dcffd0c37214705556fc68422d104b0e8932d42fc9348de60b635f3d7cd60bde73d1f326ec6547a5ccb594893251311647c70322dd4235b819ab0994358eb8582c3133b40ae888c613963b3b294d61b65d741cf99b41df1482b0ea68fec942dc167e605d4f43dd65a9fc157745b037c713fb8efd565b3f0ca76263769d26a947d0ae0bc27db82693503ec4932738c142bf5b59bc248103164e174542a5e203d3e73e2eb05dcd91fbe0767b46934355108ece5806037c495dd90c00e0bd91df90cd626be66dbd9693abde10651d97542b0de1d0e8b601499de5ac9981efb282b3a1f1abcc57fb19e816a803bcf57be0a5fc60056f03315901725fbf2e39f60654aaaa9eeaf790c6a1f8c78364161ca29951f4493779fb2df31910de102f41077f527cd6845d4e1b8e8cf190d92a63c629bd75cf1a9921ddebc0bc8f2a3834e16d4e86c3abf73fa6736d13956f81a74e461200e8a6221b2964a7ab5402d32ceaa6c3f9da5b517e9e0c12241c46c6a5733eeac5a8ecd0445a83c2d65f3423bee16c3d34d2fc6d127ba9616b1ac9a3b7475d7fb3b997ac6f56c6a84905be92e74aaf4761c1bf99008a82f8cf7ef254946019cfec0231ae83b4eb4a8b8b947b629c5804cf0d84f50dff9215b27c5ac5db085f28250f286a1f0f21f6fcb74e09b95dd2552234539d6b8c538fc5991e194bdbc655d924bd2fcc7fa6b7d89c5bb7ba1bfe524ea914ae88bbc724eaa890c73c66ec51aad9f622ed1be005f5847f6d9438f31773e8092bd061de5f609f6ea936c40f1ef435b287004e36cc3a9569ec1beff18eb950860e39e4ce6ecead97ab12636987316bb618faf0737dbae35c410b775ec11849295a391f5f3e4500cbd6506dde161db0231647541aa472a988bb95ef7ddfdc2e4b44cc2ac59fcd688b6dc6c1914ccd3f3f27bf5934a4fc378a999dadc0c842dfc906fd4ab9545b56a918eaa70a18dcc8011a3a5b5447df9b4918d1dd96b53c6f9537196fcf4ef722203d03e4a50a1a25e3dc7f99f45cb8bf7226fea3901d796e6828582e21125cb8224c9f1ae27b5bdc7c41bde4489c1a2abddcd004cff82dc3f49c38ce47223b3271f762d2d5805ff97fd08b27f45d3e3a3beaa12947d2933699c7c04bb0a91a5f0f51d0cc1d6ba47c3ad22b595900f1ada7c06b1833ecf1796fb0a7e80ee9b822653fe0e6a44804662aeaed233902acb9a7cdd631cfa8856114c14b4e95665f1260412d0fa44f18954531e19a5c577ffb10421a8f57d0260bf3c759bae52ce0207158072e99898d5f4202ccfaffef40bcc414ec49d1b49e26cf7fbf4cdf810230f7ecb9fa5a822ed4f50e7c45954b2c913142072806483cff2ed57d4929b7d963bc47fefe14d0d57fe44ed5cf6132f05afa09e4698d8655a92b61e7fa31d54073da06251c79b2a64ebe1f830922704d00e55011bc48e45b8970d5baf87863b2b1835e587507ffd60d9148a3c702fb0b43403a3ee9b5dea17fff8f8d9860e33777e39d39d59d0d1fbfb0823544f315b3399200d1bc39e5f06695ef348a7ff712c8c7f0066f2ff2fdb70451b52623cbe81b9fec6b98280bc0d005b52da9ef1c1ef7a1b279513a04f4db080cd4196e79774aa5c2a8f6ee8bbf27900023964ef0cfcea15e39cadd36e36d38f71500aaeef0af167dac3dd7b2535bf9b898e753910c873cd09155ca0cca4feeab8fd18b960dfa569a3ae47723ac853917eac7e47dec6632e4e447ec64c6ab25250f9887f6352fc21ff337dfe356b14035d7e4fc1794434587982da0a96ef09afe7d2bfd0470c8a3468bdf62c1bed6078e0977e9d8e3a322f578bbb99b9c4743931805cdc7f9ed6aca538c38528ef878813698488311a9b43ac4909c7432f86025bc6919daa684fb5c7234f96f9698241e8f81b5bcba89358defae144b9e447edb2b9faad06557b5e57a1e070246260a3b47a5c447da060a8afc7a1516d9c6fff6da9ccfadbe1022740a514cc539c46ccfa0d3057b5696e4ba9893310ee51591b6809c35aaef4f65fca6ef0b3500388a2456569dabf8214286c9d102203b071526f58131a75c11cb0af4f0fb338c44ff67355ac15e4cccc1ca41731aec7aae8775133f9a8d5f5b5df39c5595eda9263bd81eace4c92de53665567e7f9b645fa04cc2023c341c54854b56d9b814f2d558b221cac1fba993b4a6946bdfc86e46dbad9bfa34b178781c8fbf9ae0e60530ba59ff1e4a9d3718c639b4f41abf1bbd9b52ad89f4ae58278be35879e9c34acffe32571c3084e37d8fd81e1e812c28249f83596b401068479605d7973adbdc16d53780f0a8ad87387d6dc1aec79f40d3e226c120b44e33c3b6234dc6cfb7809aaad711356f276a00d0611f8ce163fde3410d546d4237570054a8967d4a21c28f5d5fd112501b6e269eaa7a41c5f3e8e0606a5c446b8c50584a79eb7f044d44cc543ccffefc18228dc6ca04418fd5b8de1a365367e8a5e93492a62b22b4dd4777564da24bed7ec3f88a3d3409f554e4a35f92e4e9f6c74f851a92ebc6c12f790d78d40f9a0a499c4d86217041d1f55f09425da89362d995c62d61401fd45ec6bc74ffdd9d4dee24fad792910a63c4c719f47fcece5a0bca0d68c99f453ac262c351fc1742e0d682d480ea8156b7b744e7cc82a8cc99f5350ebb1e59f038e92fc60155ffcce1285128215ddcfc338a1e4f7e107544ede1de945e5cf864ac861a87eb07f608afcdcf103ff6cf32ef5ca8cc8c60d198e21a50655bafaddcf8cbe4ab8c33731ddd966fb8ed97f109431b74a01e5c99785b7a476a196c8392fcbb3290b0f346ca70c5e07f728c30131911ee76243befedf882814d1c114abd4d61db9d4cbd8134c1cadbd4bdd981c63c5dc25208aacfe55ae080fec1489d5bdac89987cec18a4346ab6a5af5f04b2e232615c99517d0e9f977230bfceb69d8f9a6b9d941a47f12c27a744754d5caa8c144031bc72eafcf16f102dcbf4bc2f5b9088022b5ef03fec0aed541269213cae48ec6243f937da8c03236623fc97c421891b1b87978a74b0c972d7e3630f07b734f2fa326217d7bb0d48b51439b2490e1acb3bb59d50220f3cf0777aa778723b3e17a2437e117029f1db2740c5f96f417203e0ff6c1915631698ca9fc5982e73e6aaa71a589f21b88c8318cc5aefb037e1d5f06bacdb4a838aee5f8fe1cec2d4b4deb6b054f40f61d7329e932a471ba29b6a9fcf75e920aa43caff6972347ad788d5c6d71202f2a36418bf5aea1c780f83efc94946b7049cc22b0e1fce2de8dec389f0b5219c1ab9dc0376ad8c983b7be4c103bfd751cdf24eb587e8525bd4d0e628b8f68012ec35794e7360059952bc81bd8b60da6560987b976eb562c36c35e0c5201d1be90a37605324dabbd20b246c78e84b8df46c85d00c744ac675b4855e4374ca6794a2a42c6e6b0994bf86372c76f2d54712976d5177f7e4107254e71f495e87ddbc904717607a193fc7cf21c754fb2e0f739768b909a420f2395fffd223ecff3a6f17bb29cbc06fbcd6f2beba01d03ee32bc5a4c7d213fe766e3ab17b0b3053a21a17186585296ad3f7e4cc0a95b47e5367ebcb2bd42f988aa03dd561d43a35cbbfb17a10da4ddc460dc38d215aa91219b1d236f80a230624c3eae5102a949c2a2d8821e600598508038c74ff17d7d24af4cd0c17f30b41a3c4df59c4c312ae1da5366512afacf66d0eac651550390c3d13e683e06b3a2423956f1972ac9e36e247b77b58342c4dfb2c123625621655174de652dab2c92f57157a7684896c75f8cea7368f1918066942489b0f6f38e8ce04f95920f816556a9aa436696d24c4fa14a27e06964fbe6e658d047503436c6a16b5b6b55dc56273b4cb1d37f9dc5f75d1a52f3a2f2af36a812dc872eb5a10e359b0fb3040511c7ca9f8b26bd04b2f91c8580a5222120a6da6a715c5c04a8a1430602b0c72b0f3698eca65d605436ffca76b0845159f35e45e110a688b6d664389631f341a5ec3daedae61b9e7b9f3573cc36e785d0e460e21d0e84786b13a8d505d38d390d0b5546894a9000d6f161849f223d3670bd859e514503fdc7076f7b378d72f49c4e35de3fb219a34b39b58e3aead75b2e89e3c636a1fde994d7c8e75a1df38e0ad57a6f1b3a29f129008a974f158e97c433de0300fd1a1a8148583ffe0fcbf985d90f7871b9a022af896a2fcf0709690f16d50ddd9036b15f1158d8697eedcf80b9af69643af2daf58108dddad1e02f7afddd7f141476c0e73f5dac32a9dc4f33d93ea4d0d186323a0976614261897634e5b3473ff62af3d4edf46ddecc9fe0162192e22e33f903885765f11a40cb3d90760a266595d481b31845a0c27d1aa0e137320fb9b92ff01e821f56cbc5aaae9437990485c1ac3182d74782e9e70db06fad4a0f591a12ee51cd8fa6a5932a3e46a2b4b65c076861282a814c14e6510a5f6366a6907a7fb07c1da51974e60ccd15684a054e209aa7c8f2f990b3659d576e59920fa11acb3313e91734f78a40ee6b4a89b99aa55e0aa60806f8118cfe21978395f4a17c861e39418bc0ce8a63b1a48ba93055c7fb303bbcc48b015f6a7e2e970403971bf5b1453cb45bcc3e28f6a4e9cab0531d260a498b3e8600c9814408e5c7d7926d3e39d34912eafdfd7a69e7f2a5e6526a553495188788a5081c3c17da62d6e5e6d7049c902e5ccb75cf0483692a2d2d1e9573a1816856d3548c5671"
    } "#;
    serde_json::from_str::<Utxo>(&utxo1).unwrap();

    // Unblinded, ZC
    let utxo0 = r#" {
        "block_height": null,
        "txhash": "c2d1caf2bf5b59b5e65fb4ad7a5044d773f9171881e365060df7492be55b89cb",
        "pt_idx": 1,
        "subaccount": 1,
        "pointer": 312,
        "script_type": 14,
        "user_status": 0,
        "value": "10000",
        "subtype": 0,
        "asset_tag": "01499a818545f6bae39fc03b637f2a4e1e64e590cac1bc3a6f6d71aa4443654c14",
        "script": "a9143f0654f4f065e936f85c7fe52d4b5403430e7da887",
        "commitment": "010000000000002710",
        "nonce_commitment": "000000000000000000000000000000000000000000000000000000000000000000",
        "surj_proof": "",
        "range_proof": ""
    } "#;

    serde_json::from_str::<Utxo>(&utxo0).unwrap();
}
