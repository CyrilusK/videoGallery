//
//  AnalyticsManager.swift
//  videoGallery
//
//  Created by Cyril Kardash on 12.09.2024.
//

import UIKit
import FirebaseAnalytics

final class AnalyticsManager {
    
    private func logEvent(_ eventName: String, parameters: [String: Any]?) {
        Analytics.logEvent(eventName, parameters: parameters)
    }

    func logPlaySpeedChanged(speed: Float) {
        logEvent(K.playSpeedChanged, parameters: [K.speed: speed])
    }

    func logVideoWatchedEnd(videoTitle: String) {
        logEvent(K.videoWatchedEnd, parameters: [K.videoTitle: videoTitle])
    }
    
    func logToggleVideoFullScreen(mode: String) {
        logEvent(K.videoFullscreenToggled, parameters: [K.mode: mode])
    }
}

