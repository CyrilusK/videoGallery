//
//  AnalyticsLoggerViewInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

protocol AnalyticsLoggerViewInputProtocol: AnyObject {
    func setupUI()
    func setLogs(_ logs: [AnalyticsLog])
}
