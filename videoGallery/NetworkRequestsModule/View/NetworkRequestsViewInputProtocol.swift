//
//  NetworkRequestsViewInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

protocol NetworkRequestsViewInputProtocol: AnyObject {
    func setupUI()
    func setLogs(_ logs: [NetworkLog])
}
