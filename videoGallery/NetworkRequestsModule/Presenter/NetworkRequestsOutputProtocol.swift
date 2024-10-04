//
//  NetworkRequestsOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

protocol NetworkRequestsOutputProtocol: AnyObject {
    func viewDidLoad()
    func didFetchLogs(_ logs: [NetworkLog])
    func copyToClipboard(text: String)
}
