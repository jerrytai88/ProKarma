//
//  PostModel.swift
//  ProKarma
//
//  Created by Yu Tai on 8/13/19.
//  Copyright © 2019 Yu Tai. All rights reserved.
//

import Foundation

struct PostModel: Decodable {
    let imageUrl: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "thumbnail"
        case title
    }
}

struct datum: Decodable {
    let data: datumChildren
}

struct datumChildren: Decodable {
    let children: [datumChildData]
    let after: String
}

struct datumChildData: Decodable {
    let data: PostModel
}



