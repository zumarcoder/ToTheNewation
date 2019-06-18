//
//  GalleryImageStruct.swift
//  ToTheNewation
//
//  Created by Akash Verma on 30/05/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import Foundation
import UIKit



struct GoogleApi: Decodable {
    let items: [SubItems]
}

struct SubItems: Decodable{
    let title: String
    let image: SubImageInfo
}

struct SubImageInfo: Decodable {
    let height: Int
    let width: Int
    let thumbnailLink: String
    let thumbnailHeight: Int
    let thumbnailWidth: Int
}
