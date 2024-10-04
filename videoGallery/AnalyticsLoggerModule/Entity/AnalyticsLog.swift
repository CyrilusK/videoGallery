//
//  AnalyticsLog.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import Foundation

struct AnalyticsLog: Codable {
    let event: String
    let parameters: [String: String]
    let timestamp: Date
}
