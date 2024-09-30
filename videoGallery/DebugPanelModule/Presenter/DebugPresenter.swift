//
//  DebugPresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 30.09.2024.
//

import UIKit

final class DebugPresenter: DebugOutputProtocol {
    weak var view: DebugViewInputProtocol?
    //    var interactor: DebugInteractorInputProtocol?
    var router: DebugRouterInputProtocol?
    
    func viewDidLoad() {
        view?.setupUI()
    }
    
    func didSelectItem(at index: Int) {
        switch index {
        case 0:
            router?.navigateToFeatureToggles()
        case 1:
            router?.navigateToCrashes()
        case 2:
            router?.navigateToUnfatal()
        case 3:
            router?.navigateToLogger()
        default:
            break
        }
    }
    
    func dismiss() {
        router?.dismiss()
    }
}
