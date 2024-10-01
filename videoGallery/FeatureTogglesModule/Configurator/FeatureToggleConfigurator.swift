//
//  FeatureToggleConfigurator.swift
//  videoGallery
//
//  Created by Cyril Kardash on 01.10.2024.
//

import UIKit

final class FeatureToggleConfigurator {
    func configure() -> UIViewController {
        let view = FeatureTogglesViewController()
        let presenter = FeatureTogglePresenter()
        let interactor = FeatureToggleInteractor()
        
        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter
        
        return view
    }
}
