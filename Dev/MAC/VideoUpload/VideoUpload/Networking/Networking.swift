//
//  Networking.swift
//  VideoUpload
//
//  Created by Tim Abraham on 02.03.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import Foundation
import Alamofire
import CryptoKit

class Networking: ObservableObject {
    @Published var progressValue = 0.0
    let url: URL
    var walletAddress: String = "0x5F21318b12639fEAe73D5f4bfb426B748C93D03A"
    
    init(url: URL, walletAdress: String) {
        self.url = url
        self.walletAddress = walletAdress
    }
    
    init(url: URL) {
        self.url = url
    }
    
    func uploadEncryptedData(encryptedData: URL){
        Alamofire.upload(encryptedData, to: url.absoluteString + Endpoints.upload.path)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
                self.progressValue = progress.fractionCompleted
        }
        .responseJSON { response in
            debugPrint(response)
        }
        
        /// for more files simultaneous use multipartFormData
        //                    Alamofire.upload(multipartFormData: { multipartFormData in
        //                        multipartFormData.append(Data("one".utf8), withName: "one")
        //                        multipartFormData.append(Data("two".utf8), withName: "two")
        //                    }, to: "http://localhost:3000/upload")
        //                        .responseJSON { response in
        //                            debugPrint(response)
        //                        }
    }
    
    func downloadDecryptData(key: SymmetricKey) {
        Alamofire.request(url.absoluteString + "download")
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
        }.responseData { response in
            if let data = response.value {
                let sealedBox = try! ChaChaPoly.SealedBox(combined: data)
                let test = try! ChaChaPoly.open(sealedBox, using: key)
                let fileManager = FileManager.default
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFileDecrypted.mp4"
                fileManager.createFile(atPath: filePath, contents: test)
                
                let filePath2="\(documentsPath)/tempFileEncrypted.txt"
                fileManager.createFile(atPath: filePath2, contents: data)
            }
        }
    }
    
    func sendVideoConfigurationData(key: SymmetricKey){
        let serializedSymmetricKey = key.serialize()
        let parameters: [String: String] = [
            "symmetricKey": serializedSymmetricKey,
            "walletAddress": walletAddress
        ]
        Alamofire.request(url.absoluteString + Endpoints.symmetricKey.path, method: .post, parameters: parameters).responseJSON { response in
            if let data = response.value {
                // for testing
                print(data)
            }
        }
    }
}
