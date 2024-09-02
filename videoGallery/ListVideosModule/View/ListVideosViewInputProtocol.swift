//
//  ListVideosViewInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import Foundation

protocol ListVideosViewInputProtocol: AnyObject {
    func setupUI()
    func reloadData()
    func displayError(_ message: String)
}
