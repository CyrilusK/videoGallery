//
//  AnalyticsLoggerConfigurator.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

final class AnalyticsLoggerConfigurator {
    func configure() -> UIViewController {
        let view = AnalyticsLoggerViewController()
        let presenter = AnalyticsLoggerPresenter()
        let interactor = AnalyticsLoggerInteractor()
        
        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter
        
        return view
    }
}
