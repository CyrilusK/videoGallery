//
//  DebugConfigurator.swift
//  videoGallery
//
//  Created by Cyril Kardash on 30.09.2024.
//

import UIKit

final class DebugConfigurator {
    public func configure() -> UIViewController {
        let view = DebugViewController()
        let presenter = DebugPresenter()
        let router = DebugRouter()
        
        view.output = presenter
        presenter.view = view
        presenter.router = router
        router.entry = view
        
        return view
    }
}
