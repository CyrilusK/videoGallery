//
//  ListVideosInteractorInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

protocol ListVideosInteractorInputProtocol: AnyObject {
    func fetchVideos() async
    func fetchRemoteConfig() async
    func getThumbnails(for videos: [Video]) async -> [UIImage?]
}
