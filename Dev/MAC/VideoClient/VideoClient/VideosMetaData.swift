//
//  Video.swift
//  VideoClient
//
//  Created by Tim Abraham on 11.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import UIKit

struct VideosMetaData: Codable {
    let image: Data
    let title: String
    let description: String?
    
    private enum CodingKeys: String, CodingKey {
        case image
        case title = "Title"
        case description = "Description"
    }
    
    init(image: Data, title: String, description: String){
        self.image = image
        self.title = title
        self.description = description
    }
}
