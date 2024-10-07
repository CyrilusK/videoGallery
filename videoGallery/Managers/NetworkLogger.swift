//
//  NetworkLogger.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

final class NetworkLogger {
    var logs: [NetworkLog] = []
    
    init() {
        guard let logs = FileManager().loadLogsFromFile(nameFile: K.networkLogsJson, type: NetworkLog.self) else {
            return
        }
        self.logs = logs
    }
    
    func logRequest(url: String, method: String, statusCode: Int) {
        let logEntry = NetworkLog(timestamp: Date(), url: url, method: method, statusCode: statusCode)
        logs.append(logEntry)
        FileManager().saveLogsToFile(nameFile: K.networkLogsJson, logs: logs)
    }
}

