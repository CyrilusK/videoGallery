//
//  RemoteConfigManager.swift
//  videoGallery
//
//  Created by Cyril Kardash on 13.09.2024.
//

import UIKit
import Firebase

struct VideoPlayerUIConfig: Codable {
    let cellCount: Int  // Количество столбцов
    let backgroundColor: String  // Цвет фона
    let timeLabelTextColor: String  // Цвет шрифта времени
    let labelBackgroundColor: String  // Цвет фона лейбла и кнопок
    let segmentedControlBackgroundColor: String  // Цвет фона SegmentedControl
    let segmentedControlSelectedItemColor: String  // Цвет выбранного элемента SegmentedControl
    let sliderColor: String  // Цвет ползунка
    let videoConstraintHeight: Float  // Высота констрейнта видео в обычном режиме
    let buttonSize: Float  // Размер кнопок
    let buttonSpacing: Float  // Пространство между кнопками в контроле
    let playbackSpeeds: [Float]  // Массив скоростей воспроизведения
    var uiElementsVisibility: [String: Bool]  // Включение/выключение UI элементов
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

