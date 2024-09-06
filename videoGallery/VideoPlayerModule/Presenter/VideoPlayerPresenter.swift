//
//  VideoPlayerPresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit
import AVKit

final class VideoPlayerPresenter: VideoPlayerOutputProtocol {
    weak var view: VideoPlayerViewInputProtocol?
    var interactor: VideoPlayerInteractorInputProtocol?
    var router: VideoPlayerRouterInputProtocol?
    
    private var video: Video
    private var isPlaying = true
    private var isMuted = false
    
    init(video: Video) {
        self.video = video
    }
    
    func viewDidLoad() {
        view?.setupUI()
    }
    
    func viewDidAppear() {
        view?.setupVideoPlayer()
    }
    
    func getVideoURL() -> URL? {
        URL(string: video.videoUrl)
    }
    
    func getVideo() -> Video {
        video
    }
    
    func didTapPlayPause() {
        if isPlaying {
            view?.pauseVideo()
        }
        else {
            view?.playVideo()
        }
        isPlaying.toggle()
    }
    
    func formatTime(seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
