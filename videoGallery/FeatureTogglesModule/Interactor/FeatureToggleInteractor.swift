//
//  FeatureToggleInteractor.swift
//  videoGallery
//
//  Created by Cyril Kardash on 01.10.2024.
//

import UIKit

final class FeatureToggleInteractor: FeatureToggleInteractorInputProtocol{
    weak var output: FeatureToggleOutputProtocol?
    
    func fetchRemoteConfig() {
        Task {
            let fetchedConfig = await RemoteConfigManager.shared.fetchRemoteConfig()
            output?.getRemoteConfig(fetchedConfig)
        }
    }
    
    func saveConfig(config: VideoPlayerUIConfig?) {
        RemoteConfigManager.shared.updateRemoteConfig(with: config)
    }
    
    func resetConfig() {
        RemoteConfigManager.shared.updateRemoteConfig(with: nil)
        fetchRemoteConfig()
    }
}
