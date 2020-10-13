//
//  Created by Tim Abraham on 11.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//  Proof-Of-Concept for Bachelor Thesis
//  
//  SmartContract-Calls for documentation
//  Additionally all methods which change the blockchain state have to be signed ether transactions otherwise they wont be recorded 


const Web3 = require('web3')
const rpcURL = 'HTTP://127.0.0.1:8545'
const web3 = new Web3(rpcURL)
const address = '0xD73e38Ea87a2599652E91a8C3F0B506aA1a2cB45'
web3.eth.getBalance(address, (err, wei) => {
    balance = web3.utils.fromWei(wei, 'ether')
    console.log(balance)
})

var fs = require('fs')
let rawdata = fs.readFileSync('abi.json');
const abi = JSON.parse(rawdata);

const addressToken = "0x515Ed5443823C119d9AB66b6d68041C59129C948"
const contract = new web3.eth.Contract(abi, addressToken)

contract.methods.totalSupply().call((err, result) => {
    console.log(result)
})
contract.methods.name().call((err, result) => {
    console.log(result)
})
contract.methods.symbol().call((err, result) => {
    console.log(result)
})
contract.methods.balanceOf('0xD73e38Ea87a2599652E91a8C3F0B506aA1a2cB45').call((err, result) => {
    console.log("Wallet 1 Organisation " + result)
})
contract.methods.balanceOf('0x0182645d3c9033F8D1a91f31A5694d2Da2babD3a').call((err, result) => {
    console.log("Wallet 2 User " + result)
})
contract.methods.balanceOf('0x5F21318b12639fEAe73D5f4bfb426B748C93D03A').call((err, result) => {
    console.log("Wallet 3 User " + result)
})
contract.methods.approve('0x0182645d3c9033F8D1a91f31A5694d2Da2babD3a', 22).call((err, result) => {
    console.log("Approve User Wallet 2 " + result)
})
contract.methods.allowance('0x5F21318b12639fEAe73D5f4bfb426B748C93D03A', '0x0182645d3c9033F8D1a91f31A5694d2Da2babD3a').call((err, result) => {
    console.log("Check Allowance User Wallet 3 " + result)
})
contract.methods.transfer('0x0182645d3c9033F8D1a91f31A5694d2Da2babD3a', 22).call((err, result) => {
    console.log("transfer Tokens from Organisation to Wallet 2 " + result)
})
contract.methods.transferFrom('0x0182645d3c9033F8D1a91f31A5694d2Da2babD3a', '0x5F21318b12639fEAe73D5f4bfb426B748C93D03A', 22).call((err, result) => {
    console.log("transfer from wallet 2 to wallet 3 " + result)
})