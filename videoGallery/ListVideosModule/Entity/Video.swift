//
//  Video.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

struct Video: Decodable {
    let id: String
    let title: String
    let thumbnailUrl: String
    let duration: String
    let uploadTime: String
    let views: String
    let author: String
    let videoUrl: String
    let description: String
    let subscriber: String
    let isLive: Bool
}
