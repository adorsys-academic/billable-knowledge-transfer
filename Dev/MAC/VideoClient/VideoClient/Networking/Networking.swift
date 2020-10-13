//
//  Networking.swift
//  VideoClient
//
//  Created by Tim Abraham on 11.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import Alamofire
import CryptoKit

class Networking {
    let url: URL
    let fileManager = FileManager.default
    var walletAdress: String = "0x0182645d3c9033F8D1a91f31A5694d2Da2babD3a"
    
    init(url: URL, walletAdress: String) {
        self.url = url
        self.walletAdress = walletAdress
    }
    
    init(url: URL) {
        self.url = url
    }
    
    func download(){
        let parameters: [String: String] = [
            "walletAddress": walletAdress
        ]
        Alamofire.request(url.absoluteString + Endpoints.pay.path, method: .post, parameters: parameters).response { response in
            if let data = response.data {
                if let deserializedSymmetricKey = self.decodeSymmetricKey(data: data){
                    Alamofire.request(self.url.absoluteString + "download")
                        .downloadProgress { progress in
                            print("Download Progress: \(progress.fractionCompleted)")
                    }.responseData { response in
                        if let data = response.value {
                            let sealedBox = try! ChaChaPoly.SealedBox(combined: data)
                            let decryptedVideo = try! ChaChaPoly.open(sealedBox, using: deserializedSymmetricKey)
                            self.writeToFile(content: decryptedVideo)
                        }
                    }
                }
            }
        }
    }
    
    func writeToFile(content: Data) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/video.mp4"
        fileManager.createFile(atPath: filePath, contents: content)
    }
    
    func deleteFromFile(fileName: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(atPath: destinationPath)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
    }
    
    func decodeSymmetricKey(data: Data) -> SymmetricKey?{
        let decoder = JSONDecoder()
        let key = try? decoder.decode(VideoDownload.self, from: data)
        if let serializedKey = key {
            let deserializedSymmetricKey = SymmetricKey(base64EncodedString: serializedKey.symmetricKey)
            return deserializedSymmetricKey
        } else {
            print("deserializedSymmetricKey was nil.")
            return nil
        }
    }
}

struct VideoDownload: Codable {
    var symmetricKey: String
}

extension URL    {
    func checkFileExist() -> Bool {
        let path = self.path
        if (FileManager.default.fileExists(atPath: path))   {
            print("FILE AVAILABLE")
            return true
        }else        {
            print("FILE NOT AVAILABLE")
            return false;
        }
    }
}
