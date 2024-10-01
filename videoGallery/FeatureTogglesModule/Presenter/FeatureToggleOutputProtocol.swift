//
//  FeatureToggleOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 01.10.2024.
//

import UIKit

protocol FeatureToggleOutputProtocol: AnyObject {
    func viewDidLoad()
    func saveConfig(config: VideoPlayerUIConfig?)
    func resetConfig()
    func getRemoteConfig(_ config: VideoPlayerUIConfig?)
}

