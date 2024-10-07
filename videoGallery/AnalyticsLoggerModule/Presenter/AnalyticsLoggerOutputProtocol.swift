//
//  AnalyticsLoggerOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

protocol AnalyticsLoggerOutputProtocol: AnyObject {
    func viewDidLoad()
    func didFetchLogs(_ logs: [AnalyticsLog])
}
