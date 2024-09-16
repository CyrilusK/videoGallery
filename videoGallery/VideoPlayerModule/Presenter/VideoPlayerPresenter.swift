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
    
    private var hideControlsTimer: Timer?
    
    init(video: Video) {
        self.video = video
    }
    
    func viewDidLoad() {
        interactor?.fetchRemoteConfig()
    }
    
    func getRemoteConfig(_ config: VideoPlayerUIConfig) {
        self.view?.setConfigUI(config: config)
        DispatchQueue.main.async {
            self.view?.setupUI()
        }
        self.startHideControlsTimer()
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
            if let player = interactor?.getValuesPlayer(), player.currentTime() == player.currentItem?.duration {
                interactor?.replayVideo()
            } else {
                interactor?.playVideo()
            }
        }
        isPlaying.toggle()
        view?.updatePlayPauseButton(isPlaying: isPlaying)
        view?.showControls()
    }
    
    func didTapMute() {
        isMuted.toggle()
        interactor?.setMute(isMuted: isMuted)
        view?.updateMuteButton(isMuted: isMuted)
        view?.showControls()
    }
    
    func didTapSkipForward() {
        interactor?.skip(forward: true)
        view?.showControls()
    }
    
    func didTapSkipBackward() {
        interactor?.skip(forward: false)
        view?.showControls()
    }
    
    
    func didSeekToPosition(sliderValue: Float) {
        interactor?.seekToPosition(sliderValue: sliderValue)
        view?.showControls()
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
    
    func startHideControlsTimer() {
        hideControlsTimer?.invalidate()
        hideControlsTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    @objc private func hideControls() {
        view?.hideControls()
    }
    
    func videoDidFinishPlaying() {
        AnalyticsManager().logVideoWatchedEnd(videoTitle: video.title)
        isPlaying.toggle()
        view?.updatePlayPauseButtonToReplay()
        view?.showControls()
    }
    
    func didChangeSpeed(selectedIndex: Int) {
        guard let speeds = view?.getPlaybackSpeeds(), selectedIndex < speeds.count else {
            return
        }
        let rate = speeds[selectedIndex]
        
        interactor?.setPlayRate(rate: rate)
        view?.updateTitleChangeSpeedButton(title: "\(rate)x")
        AnalyticsManager().logPlaySpeedChanged(speed: rate)
        view?.showControls()
    }

    private func getRate(from index: Int, speeds: [Float]) -> Float {
        guard index < speeds.count else {
            return 1.0
        }
        return speeds[index]
    }
}
