//
//  SetValuesInteractor.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.10.2024.
//

import UIKit

final class SetValuesInteractor: SetValuesInteractorInputProtocol{
    weak var output: SetValuesOutputProcotol?
    
    func fetchRemoteConfig() {
        Task {
            let fetchedConfig = await RemoteConfigManager.shared.fetchRemoteConfig()
            output?.setConfigUI(fetchedConfig)
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
