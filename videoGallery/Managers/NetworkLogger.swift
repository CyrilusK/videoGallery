//
//  NetworkLogger.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

final class NetworkLogger: URLProtocol {
    static var logs: [(url: String, method: String, statusCode: Int, date: Date)] = []

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url?.absoluteString, let method = request.httpMethod else { return false }
        let logEntry = (url: url, method: method, statusCode: 200, date: Date())
        NetworkLogger.logs.append(logEntry)
        return false
    }
    
    func logRequest(url: String, method: String, statusCode: Int) {
        let logEntry = (url: url, method: method, statusCode: statusCode, date: Date())
        NetworkLogger.logs.append(logEntry)
    }
}
