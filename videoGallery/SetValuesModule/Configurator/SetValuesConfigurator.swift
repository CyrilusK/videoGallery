//
//  SetValuesConfigurator.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.10.2024.
//

import UIKit

final class SetValuesConfigurator {
    func configure() -> UIViewController {
        let view = SetValuesViewController()
        let presenter = SetValuesPresenter()
        let interactor = SetValuesInteractor()
        
        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter
        
        return view
    }
}
