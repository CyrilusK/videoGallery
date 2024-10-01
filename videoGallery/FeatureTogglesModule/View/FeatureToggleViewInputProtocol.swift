//
//  FeatureToggleViewInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 01.10.2024.
//

import UIKit

protocol FeatureToggleViewInputProtocol: AnyObject {
    func setupUI()
    func setConfigUI(config: VideoPlayerUIConfig?)
}
