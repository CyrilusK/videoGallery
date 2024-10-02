//
//  Constants.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import Foundation

struct K {
    static let invalidURL = "Invalid URL"
    static let noData = "No data received"
    static let decodingError = "Failed to decode data:"
    static let networkError = "Network error:"
    static let serverError = "Failed to download image from server"
    
    static let urlAPI = "https://demo0015790.mockable.io"
    
    static let reuseIdentifier = "VideoCell"
    
    static let skipInterval: Double = 10.0
    static let timeObserverInterval: Double = 0.3
    static let alphaComponent: Double = 0.2
    static let dismissibleHeight: CGFloat = 200
    static let timeAnimate : Double = 0.5
    
    // analytics
    static let videoWatchedEnd = "video_watched_to_end"
    static let videoTitle = "video_title"
    static let playSpeedChanged = "play_speed_changed"
    static let speed = "speed"
    static let videoFullscreenToggled = "video_fullscreen_toggled"
    static let mode = "mode"
    static let fullscreen = "fullscreen"
    static let normal = "normal"
    static let keyForRemoteConfig = "video_player_ui_config"
    
    //debug menu
    static let cell = "cell"
    static let CFBundleShortVersion = "CFBundleShortVersionString"
    static let CFBundleVersion = "CFBundleVersion"
    static let toggleCell = "toggleCell"
    static let featureToggles = "🚩 Feature toggles"
    static let setValues = "✏️ Кастомизация"
    static let networkRequests = "🌐 Cетевые запросы"
    static let crashes = "❌ Краши (fatal ошибки)"
    static let nonfatal = "⚠️ Non-fatal ошибки"
    static let logs = "💬 Логи аналитики"
    
    static let columnCount = "columnCount"
    static let backgroundColor = "backgroundColor"
    static let timeLabelTextColor = "timeLabelTextColor"
    static let labelBackgroundColor = "labelBackgroundColor"
    static let segmentBackgroundColor = "segmentBackgroundColor"
    static let segmentSelectedItemColor = "segmentSelectedItemColor"
    static let sliderColor = "sliderColor"
    static let videoConstraintHeight = "videoConstraintHeight"
    static let buttonSize = "buttonSize"
    static let buttonSpacing = "buttonSpacing"
    static let enterColorName = "Enter color name"
}
