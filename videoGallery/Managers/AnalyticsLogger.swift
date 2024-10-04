//
//  AnalyticsLogger.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

final class AnalyticsLogger {
    var logs: [AnalyticsLog] = []
    
    init() {
        guard let logs = FileManager().loadLogsFromFile(nameFile: K.analyticsLogJson, type: AnalyticsLog.self) else {
            return
        }
        self.logs = logs
    }
    
    private func logEvent(event: String, parameters: [String: String] = [:]) {
        let log = AnalyticsLog(event: event, parameters: parameters, timestamp: Date())
        logs.append(log)
        FileManager().saveLogsToFile(nameFile: K.analyticsLogJson, logs: logs)
    }
    
    func logPlaySpeedChanged(speed: Float) {
        logEvent(event: K.playSpeedChanged, parameters: [K.speed: "\(speed)"])
    }
    
    func logVideoWatchedEnd(videoTitle: String) {
        logEvent(event: K.videoWatchedEnd, parameters: [K.videoTitle: videoTitle])
    }
    
    func logToggleVideoFullScreen(mode: String) {
        logEvent(event: K.videoFullscreenToggled, parameters: [K.mode: mode])
    }
}

