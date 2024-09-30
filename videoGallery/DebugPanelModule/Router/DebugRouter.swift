//
//  DebugRouter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 30.09.2024.
//

import UIKit

final class DebugRouter: DebugRouterInputProtocol {
    weak var entry: UIViewController?
    
    func dismiss() {
        entry?.dismiss(animated: true)
    }
    
    func navigateToFeatureToggles() {
        let featureTogglesVC = FeatureTogglesViewController()
        entry?.navigationController?.pushViewController(featureTogglesVC, animated: true)
//        let navigationController = UINavigationController(rootViewController: featureTogglesVC)
//        entry?.present(navigationController, animated: true)
    }
    
    func navigateToCrashes() {
//        let crashesVC = CrashesViewController()
//        entry?.navigationController?.pushViewController(crashesVC, animated: true)
    }
    func navigateToUnfatal() {
//        let unfatalVC = UnfatalViewController()
//        self.navigationController?.pushViewController(unfatalVC, animated: true)
    }
    
    func navigateToLogger() {
//        let loggerVC = LoggerViewController()
//        self.navigationController?.pushViewController(loggerVC, animated: true)
    }
}
