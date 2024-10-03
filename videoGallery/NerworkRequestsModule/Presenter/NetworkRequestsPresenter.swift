//
//  NetworkRequestsPresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

final class NetworkRequestsPresenter: NetworkRequestsOutputProtocol {
    weak var view: NetworkRequestsViewInputProtocol?
    var interactor: NetworkRequestsInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.fetchLogs()
        view?.setupUI() 
    }
    
    func didFetchLogs(_ logs: [NetworkLog]) {
        view?.setLogs(logs)
    }
    
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
}
