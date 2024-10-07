//
//  AnalyticsLoggerInteractor.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

final class AnalyticsLoggerInteractor: AnalyticsLoggerInteractorInputProtocol {
    weak var output: AnalyticsLoggerOutputProtocol?
    
    func fetchLogs() {
        let logs = AnalyticsLogger().logs
        output?.didFetchLogs(logs)
    }
}
