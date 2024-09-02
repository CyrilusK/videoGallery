//
//  ListVideosConfigurator.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

final class ListVideosConfigurator {
    public func configure() -> UIViewController {
        let view = ListVideosViewController()
        let interactor = ListVideosInteractor()
        let presenter = ListVideosPresenter()
        let router = ListVideosRouter()
        
        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.entry = view
        
        return view
    }
}
