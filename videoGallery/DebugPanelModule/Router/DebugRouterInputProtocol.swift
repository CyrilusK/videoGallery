//
//  DebugRouterInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 30.09.2024.
//

import UIKit

protocol DebugRouterInputProtocol {
    func dismiss()
    func navigateToFeatureToggles()
    func navigateToCrashes()
    func navigateToUnfatal()
    func navigateToLogger()
}
