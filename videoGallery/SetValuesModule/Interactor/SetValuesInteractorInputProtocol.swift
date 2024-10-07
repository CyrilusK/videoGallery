//
//  SetValuesInteractorInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.10.2024.
//

import UIKit

protocol SetValuesInteractorInputProtocol: AnyObject {
    func fetchRemoteConfig()
    func saveConfig(config: VideoPlayerUIConfig?)
    func resetConfig()
}
