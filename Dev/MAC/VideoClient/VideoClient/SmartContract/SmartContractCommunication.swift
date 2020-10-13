//
//  SmartContractCommunication.swift
//  VideoClient
//
//  Created by Tim Abraham on 11.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import Foundation
import Web3

class SmartContractCommunication {
    let contractAddress = EthereumAddress(hexString: "0x515Ed5443823C119d9AB66b6d68041C59129C948")
    let etherMock = Web3(rpcURL: "http://127.0.0.1:8545")
    var contract: DynamicContract?
    var balance: BigUInt = 0
    
    init(){
        etherMock.clientVersion { (Web3Response) in
            print(Web3Response)
        }
        guard let jsonAbi = loadAbi() else {return}
        contract = try! etherMock.eth.Contract(json: jsonAbi, abiKey: nil, address: contractAddress)
    }
    
    func balanceOf(walletAdress: String){
        guard let contract = contract else { return }
        do {
            let balanceOf = (try contract["balanceOf"]!(EthereumAddress(hex: walletAdress, eip55: true)).createCall())!
            contract.call(balanceOf, outputs: [.init(name: "", type: .uint256)]) { (response, error) in
                if let response = response {
                    self.balance = response[""] as? BigUInt ?? 0
                }
            }
        } catch {
            fatalError("Balance Call fails")
        }
    }
    
    func loadAbi() -> Data? {
        if let path = Bundle.main.path(forResource: "abi", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return data
        }
        return nil
    }
}
