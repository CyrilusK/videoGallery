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
    private var isPlaying = true
    private var isMuted = false
    var isThumbSeek = false
    
    init(video: Video) {
        self.video = video
    }
    
    func viewDidLoad() {
        view?.setupUI()
    }
    
    func viewDidAppear() {
        interactor?.loadVideo(url: video.videoUrl)
        view?.setupVideoPlayerLayer(player: interactor?.getValuesPlayer())
    }
    
    func didTapPlayPause() {
        if isPlaying {
            interactor?.pauseVideo()
        }
        else {
            interactor?.playVideo()
        }
        isPlaying.toggle()
        view?.updatePlayPauseButton(isPlaying: isPlaying)
    }
    
    func didTapMute() {
        isMuted.toggle()
        interactor?.setMute(isMuted: isMuted)
        view?.updateMuteButton(isMuted: isMuted)
    }
    
    func didTapSkipForward() {
        interactor?.skip(forward: true)
    }
    
    func didTapSkipBackward() {
        interactor?.skip(forward: false)
    }
    
    
    func didSeekToPosition(sliderValue: Float) {
        interactor?.seekToPosition(sliderValue: sliderValue)
    }
    
    func didClose() {
        router?.dismiss()
    }
    
    func updateTime(currentTime: Float, totalTime: Float) {
        let currentTimeFormatted = formatTime(seconds: currentTime)
        let totalTimeFormatted = formatTime(seconds: totalTime)
        
        if !isThumbSeek {
            view?.updateTimeSlider(percent: currentTime / totalTime)
        }
        view?.updateTimeLabels(currentTime: currentTimeFormatted, totalTime: totalTimeFormatted)
    }
    
    func getFormattedDuration() -> String {
        return formatTime(seconds: Float(interactor?.getDuration() ?? 0.0))
    }
    
    private func formatTime(seconds: Float) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
