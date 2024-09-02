//
//  ListVideosOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import Foundation

protocol ListVideosOutputProtocol: AnyObject {
    func viewDidLoad()
    func didFetchVideos(_ videos: [Video])
    func showError(_ error: Error)
}
