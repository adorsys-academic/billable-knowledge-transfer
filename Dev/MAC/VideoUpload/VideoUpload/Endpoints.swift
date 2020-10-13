//
//  Endpoints.swift
//  VideoUpload
//
//  Created by Tim Abraham on 12.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

enum Endpoints: String {
    case upload
    case download
    case symmetricKey
    case pay
    
    var path : String {
        switch self {
        case .upload: return "upload"
        case .download: return "download"
        case .symmetricKey: return "symmetricKey"
        case .pay: return "payForContentReceiveSymmetricKey"
        }
    }
}
