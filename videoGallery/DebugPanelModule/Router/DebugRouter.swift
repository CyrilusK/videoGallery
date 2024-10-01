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
        let featureTogglesVC = FeatureToggleConfigurator().configure()
        entry?.navigationController?.pushViewController(featureTogglesVC, animated: true)
    }
    
    func navigateToSetValues() {
        
    }
    
    func navigateToNetworkRequests() {
        
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
