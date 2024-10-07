//
//  ListVideosOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

protocol ListVideosOutputProtocol: AnyObject {
    var videos: [Video] { get }
    var config: VideoPlayerUIConfig? { get }
    
    func viewDidLoad()
    func didFetchVideos(_ videos: [Video])
    func showError(_ error: Error)
    func getVideo(at indexPath: IndexPath) -> Video
    func didSelectVideo(at indexPath: IndexPath)
    func getThumbnail(at indexPath: IndexPath) -> UIImage?
    func getRemoteConfig(_ config: VideoPlayerUIConfig)
    func presentDebug()
}
