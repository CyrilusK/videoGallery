//
//  RemoteConfigManager.swift
//  videoGallery
//
//  Created by Cyril Kardash on 13.09.2024.
//

import UIKit
import Firebase

struct VideoPlayerUIConfig: Codable {
    var cellCount: Int  // Количество столбцов
    var backgroundColor: String  // Цвет фона
    var timeLabelTextColor: String  // Цвет шрифта времени
    var labelBackgroundColor: String  // Цвет фона лейбла и кнопок
    var segmentedControlBackgroundColor: String  // Цвет фона SegmentedControl
    var segmentedControlSelectedItemColor: String  // Цвет выбранного элемента SegmentedControl
    var sliderColor: String  // Цвет ползунка
    var videoConstraintHeight: Float  // Высота констрейнта видео в обычном режиме
    var buttonSize: Float  // Размер кнопок
    var buttonSpacing: Float  // Пространство между кнопками в контроле
    var playbackSpeeds: [Float]  // Массив скоростей воспроизведения
    var uiElementsVisibility: [String: Bool]  // Включение/выключение UI элементов
    
    func toDictionary() -> [String: String] {
        return [
            K.columnCount: "\(cellCount)",
            K.backgroundColor: backgroundColor,
            K.timeLabelTextColor: timeLabelTextColor,
            K.labelBackgroundColor: labelBackgroundColor,
            K.segmentBackgroundColor: segmentedControlBackgroundColor,
            K.segmentSelectedItemColor: segmentedControlSelectedItemColor,
            K.sliderColor: sliderColor,
            K.videoConstraintHeight: "\(videoConstraintHeight)",
            K.buttonSize: "\(buttonSize)",
            K.buttonSpacing: "\(buttonSpacing)"
        ]
    }
}

final class RemoteConfigManager {
    static let shared = RemoteConfigManager()

    private var remoteConfig: RemoteConfig
    private var currentConfig: VideoPlayerUIConfig?
    
    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    func fetchRemoteConfig() async -> VideoPlayerUIConfig? {
        if let config = currentConfig {
            return config
        }
        
        do {
            try await remoteConfig.fetchAndActivate()
            guard let jsonString = remoteConfig.configValue(forKey: K.keyForRemoteConfig).stringValue else {
                print("[DEBUG] – JSON не найден в Remote Config")
                return nil
            }
            let jsonData = Data(jsonString.utf8)
            let config = try JSONDecoder().decode(VideoPlayerUIConfig.self, from: jsonData)
            currentConfig = config
            return config
        } catch {
            print("[DEBUG] – Ошибка декодирования JSON: \(error)")
            Crashlytics.crashlytics().record(error: error)
            return nil
        }
    }
    
    func updateRemoteConfig(with config: VideoPlayerUIConfig?) {
        currentConfig = config
    }
}

