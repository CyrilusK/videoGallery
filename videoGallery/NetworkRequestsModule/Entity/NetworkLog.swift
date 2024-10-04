//
//  NetworkLog.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import Foundation

struct NetworkLog: Codable {
    let timestamp: Date
    let url: String
    let method: String
    let statusCode: Int
}
