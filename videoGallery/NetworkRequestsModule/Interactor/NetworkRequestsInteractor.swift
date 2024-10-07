//
//  NetworkRequestsInteractor.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

final class NetworkRequestsInteractor: NetworkRequestsInteractorInputProtocol {
    weak var output: NetworkRequestsOutputProtocol?
    
    func fetchLogs() {
        let logs = NetworkLogger().logs
        output?.didFetchLogs(logs)
    }
}
