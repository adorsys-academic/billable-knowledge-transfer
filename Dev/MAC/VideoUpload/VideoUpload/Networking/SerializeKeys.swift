//
//  SearilizeKeys.swift
//  VideoUpload
//
//  Created by Tim Abraham on 10.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//
//  Related to: https://stackoverflow.com/questions/56828125/how-do-i-access-the-underlying-key-of-a-symmetrickey-in-cryptokit
//  Called on May 10th.
//

import Foundation
import CryptoKit

extension SymmetricKey {

    // MARK: Custom Initializers

    /// Creates a `SymmetricKey` from a Base64-encoded `String`.
    ///
    /// - Parameter base64EncodedString: The Base64-encoded string from which to generate the `SymmetricKey`.
    init?(base64EncodedString: String) {
        guard let data = Data(base64Encoded: base64EncodedString) else {
            return nil
        }

        self.init(data: data)
    }

    // MARK: - Instance Methods

    /// Serializes a `SymmetricKey` to a Base64-encoded `String`.
    func serialize() -> String {
        return self.withUnsafeBytes { body in
            Data(body).base64EncodedString()
        }
    }
}
