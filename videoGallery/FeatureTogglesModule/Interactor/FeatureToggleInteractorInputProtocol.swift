//
//  FeatureToggleInteractorInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 01.10.2024.
//

import UIKit

protocol FeatureToggleInteractorInputProtocol: AnyObject {
    func fetchRemoteConfig()
    func saveConfig(config: VideoPlayerUIConfig?)
    func resetConfig()
}
