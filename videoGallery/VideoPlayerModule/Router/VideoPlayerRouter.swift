//
//  VideoPlayerRouter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit

final class VideoPlayerRouter: VideoPlayerRouterInputProtocol {
    weak var entry: UIViewController?
    
    func dismiss() {
        entry?.dismiss(animated: false, completion: nil)
    }
    
    func presentDebug() {
        let debugVC = DebugConfigurator().configure()
        let navController = UINavigationController(rootViewController: debugVC)
        navController.modalPresentationStyle = .fullScreen
        entry?.present(navController, animated: true)
    }
}
