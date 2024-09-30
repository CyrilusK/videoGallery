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
//        if #available(iOS 16, *) {
//            videoPlayerVC.isModalInPresentation = true
//            if let sheet = videoPlayerVC.sheetPresentationController {
//                sheet.detents = [.custom(resolver: { context in
//                    0.35 * context.maximumDetentValue
//                }), .custom(resolver: { context in
//                    0.7 * context.maximumDetentValue
//                }), .large()]
//            }
//        }
        videoPlayerVC.modalPresentationStyle = .overFullScreen
        entry?.present(videoPlayerVC, animated: false)
    }
    
    func presentDebug() {
        let debugVC = DebugConfigurator().configure()
        let navController = UINavigationController(rootViewController: debugVC)
        navController.modalPresentationStyle = .fullScreen
        entry?.present(navController, animated: true)
    }
}
