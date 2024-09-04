//
//  ListVideosRouter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

final class ListVideosRouter: ListVideosRouterInputProtocol {
    weak var entry: UIViewController?
    
    func presentVideoDetail(_ video: Video) {
        let videoPlayerVC = VideoPlayerConfigurator().configure(video: video)
        videoPlayerVC.modalPresentationStyle = .fullScreen
        videoPlayerVC.modalTransitionStyle = .coverVertical
        entry?.present(videoPlayerVC, animated: true)
    }
}
