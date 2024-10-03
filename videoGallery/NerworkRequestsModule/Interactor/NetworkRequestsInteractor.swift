//
//  NetworkRequestsInteractor.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

final class NetworkRequestsInteractor: NetworkRequestsInteractorInputProtocol{
    weak var output: NetworkRequestsOutputProtocol?
    
    func fetchLogs() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss, dd/MM/yyyy"
        
        let logs = NetworkLogger.logs.map { log in
            let timestamp = dateFormatter.string(from: log.date)
            return NetworkLog(timestamp: timestamp, url: log.url, method: log.method, statusCode: log.statusCode)
        }
        output?.didFetchLogs(logs)
    }
}
