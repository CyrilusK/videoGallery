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
        let setValuesVC = SetValuesConfigurator().configure()
        entry?.navigationController?.pushViewController(setValuesVC, animated: true)
    }
    
    func navigateToNetworkRequests() {
        let networkVC = NetworkRequestsConfigurator().configure()
        entry?.navigationController?.pushViewController(networkVC, animated: true)
    }
    
    func navigateToLogger() {
        let analyticsVC = AnalyticsLoggerConfigurator().configure()
        entry?.navigationController?.pushViewController(analyticsVC, animated: true)
    }
}
