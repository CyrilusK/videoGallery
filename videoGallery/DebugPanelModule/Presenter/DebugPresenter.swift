//
//  DebugPresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 30.09.2024.
//

import UIKit

final class DebugPresenter: DebugOutputProtocol {
    weak var view: DebugViewInputProtocol?
    var router: DebugRouterInputProtocol?
    
    func viewDidLoad() {
        view?.setupUI()
    }
    
    func didSelectItem(at index: Int) {
        switch index {
        case 0:
            router?.navigateToFeatureToggles()
        case 1:
            router?.navigateToSetValues()
        case 2:
            router?.navigateToNetworkRequests()
        case 3:
            router?.navigateToCrashes()
        case 4:
            router?.navigateToUnfatal()
        case 5:
            router?.navigateToLogger()
        default:
            break
        }
    }
    
    func dismiss() {
        router?.dismiss()
    }
}
