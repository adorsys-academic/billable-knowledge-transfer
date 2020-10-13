//
//  Created by Tim Abraham on 11.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//  Proof-Of-Concept for Bachelor Thesis
//  

// express REST-Server config
var express = require('express')
var app = express()
var fs = require('fs')
let rawdata = fs.readFileSync('abi.json')
const formidableExpress = require('express-formidable')
app.use(formidableExpress())

// SmartContract config
const Web3 = require('web3')
const rpcURL = 'HTTP://127.0.0.1:8545'
const web3 = new Web3(rpcURL)
const addressCompanyWallet = '0xD73e38Ea87a2599652E91a8C3F0B506aA1a2cB45'
const addressContract = "0x515Ed5443823C119d9AB66b6d68041C59129C948"
const abi = JSON.parse(rawdata);
const contract = new web3.eth.Contract(abi, addressContract)
const Tx = require("ethereumjs-tx").Transaction

// for testing - All the data should be saved in a Database 
var video
var senderWalletAddress
var symmetricKeyRaw

// for default GET-Request send metadata for possible content
app.get('/', function (req, res) {
    // implementation not part of the thesis
    res.send("metaData")
});

app.get('/download', function (req, res) {
    res.download(video)
    console.log("Download was succesful!")
});

// for default POST-Request authenticate with WalletAddress
app.post('/', function (req, res) {
    senderWalletAddress = req.fields.walletAddress
    res.status(200).json({
        status: "ok"
    })
});

// send symmetricKey to Server 
// save in database // for testing variables
app.post('/symmetricKey', function (req, res) {
    symmetricKeyRaw = req.fields.symmetricKey
    senderWalletAddress = req.fields.walletAddress
    res.status(200).json({
        status: "ok"
    })
});

// upload files
app.post('/upload', function (req, res) {
    video = req.files.file.path

    // for presentation write encrypted video to file
    fs.writeFileSync("encryptedVideoPath.txt", video)
    console.log("Upload was successful!")
    res.status(200).json({
        status: "ok"
    })
});

// 1. the video receiver sends its wallet Address
// 2. checking the balance of the wallet 
// 3. checking the approve of tokens to the wallet of the company 
// 4. a signed transaction from the companys' wallet starts and sends the tokens for the video from the receiver to the producer of the video 
app.post('/payForContentReceiveSymmetricKey', function (req, res) {
    console.log("Transaction was successful!")
    let receiverWalletAddress = req.fields.walletAddress
    contract.methods.balanceOf(req.fields.walletAddress).call((err, result) => {
        if (result > 0 && (video != null)) {
            contract.methods.allowance(receiverWalletAddress, addressCompanyWallet).call((err, result) => {
                if (result > 0) {
                    web3.eth.defaultAccount = addressCompanyWallet;

                    // for prototyping not encrypted
                    const privateKey = Buffer.from('9b118c5b54b8794051adf59a5f26ccd5a2c177b0662fea4213eab6871be7c44c', 'hex');

                    // the contract method call
                    const myData = contract.methods.transferFrom(receiverWalletAddress, senderWalletAddress, 11).encodeABI();

                    web3.eth.getTransactionCount(addressCompanyWallet, (err, txCount) => {
                        // build the transaction
                        const txObject = {
                            nonce: web3.utils.toHex(txCount),
                            to: addressContract,
                            value: web3.utils.toHex(web3.utils.toWei('0', 'ether')),
                            gasLimit: web3.utils.toHex(2100000),
                            gasPrice: web3.utils.toHex(web3.utils.toWei('6', 'gwei')),
                            data: myData
                        }
                        // sign the transaction because blockchain state will be changed
                        const tx = new Tx(txObject);
                        tx.sign(privateKey);

                        const serializedTx = tx.serialize();
                        const raw = '0x' + serializedTx.toString('hex');

                        // broadcast the transaction
                        const transaction = web3.eth.sendSignedTransaction(raw, (err, tx) => {
                            // after successful transaction -> send symmetricKey
                            res.send({
                                symmetricKey: symmetricKeyRaw
                            })
                        });
                    });
                }
            })
        }
    })
});

app.listen(3000, function () {
    console.log('App listening on port 3000!');
});

// for multipart Forms use ---> 
// new formidable.IncomingForm().parse(req, (err, fields, files) => {
//     if (err) {
//         console.error('Error', err)
//         throw err
//     }
//     console.log('Fields', fields)
//     res.send(fields)
//     // console.log('Files', files)
//     for (const file of Object.entries(files)) {
//         // console.log(file)
//         // console.log(file.path)
//         // console.log(file.name)
//         console.log(file)
//     }
// })