//
//  FeatureTogglePresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 01.10.2024.
//

import UIKit

final class FeatureTogglePresenter: FeatureToggleOutputProtocol {
    weak var view: FeatureToggleViewInputProtocol?
    var interactor: FeatureToggleInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.fetchRemoteConfig()
        view?.setupUI()
    }
    
    func saveConfig(config: VideoPlayerUIConfig?) {
        interactor?.saveConfig(config: config)
    }
    
    func resetConfig() {
        interactor?.resetConfig()
    }
    
    func getRemoteConfig(_ config: VideoPlayerUIConfig?) {
        view?.setConfigUI(config: config)
    }
}
