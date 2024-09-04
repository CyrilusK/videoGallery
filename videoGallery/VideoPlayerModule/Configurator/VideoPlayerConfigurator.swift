//
//  VideoPlayerConfigurator.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit

final class VideoPlayerConfigurator {
    func configure(video: Video) -> UIViewController {
        let view = VideoPlayerViewController()
        let presenter = VideoPlayerPresenter(video: video)
        let router = VideoPlayerRouter()
        let interactor = VideoPlayerInteractor()
        
        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.entry = view
        
        return view
    }
}
