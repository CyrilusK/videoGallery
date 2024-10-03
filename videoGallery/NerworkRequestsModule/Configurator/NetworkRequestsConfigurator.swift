//
//  NetworkRequestsConfigurator.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

final class NetworkRequestsConfigurator {
    func configure() -> UIViewController {
        let view = NetworkRequestsViewController()
        let presenter = NetworkRequestsPresenter()
        let interactor = NetworkRequestsInteractor()
        
        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter
        
        return view
    }
}
