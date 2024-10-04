//
//  AnalyticsLoggerPresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

final class AnalyticsLoggerPresenter: AnalyticsLoggerOutputProtocol {
    weak var view: AnalyticsLoggerViewInputProtocol?
    var interactor: AnalyticsLoggerInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.fetchLogs()
        view?.setupUI()
    }
    
    func didFetchLogs(_ logs: [AnalyticsLog]) {
        view?.setLogs(logs)
    }
}
