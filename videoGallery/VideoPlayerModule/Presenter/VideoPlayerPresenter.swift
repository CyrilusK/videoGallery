//
//  VideoPlayerPresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit

final class VideoPlayerPresenter: VideoPlayerOutputProtocol {
    weak var view: VideoPlayerViewInputProtocol?
    var interactor: VideoPlayerInteractorInputProtocol?
    var router: VideoPlayerRouterInputProtocol?
    
    private var video: Video
    
    init(video: Video) {
        self.video = video
    }
    
    func viewDidLoad() {
        view?.setupVideoPlayer(with: video)
    }
    
    func getVideoURL() -> URL? {
        URL(string: video.videoUrl)
    }
}
