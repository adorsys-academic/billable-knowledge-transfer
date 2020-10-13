//
//  Encryption.swift
//  VideoUpload
//
//  Created by Tim Abraham on 10.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import Foundation
import CryptoKit

class Encryption {
    let key = SymmetricKey(size: .bits256)
    let file: URL
    
    init(file: URL) {
        self.file = file
    }
    
    func encryptFile() -> URL{
        let originalFile = FileManager.default.contents(atPath: file.relativePath)!
        let encryptedData = try! ChaChaPoly.seal(originalFile, using: self.key).combined
        
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("test.mp4")
        do {
            try encryptedData.write(to: fileURL)
            return fileURL
        } catch {
            fatalError("\(error)")
        }
    }
}
