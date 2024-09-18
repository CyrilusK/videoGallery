//
//  VideoPlayerInteractor.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit
import AVKit
import Firebase

final class VideoPlayerInteractor: VideoPlayerInteractorInputProtocol {
    weak var output: VideoPlayerOutputProtocol?
    
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    
    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    func loadVideo(url: String) {
        guard let videoURL = URL(string: url) else { return }
        player = AVPlayer(url: videoURL)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        setupPeriodicTimeObserver()
        playVideo()
    }
    
    func seekToPosition(sliderValue: Float) {
        output?.isThumbSeek = true
        let totalTime = getDuration()
        let seekTime = CMTime(seconds: totalTime * Float64(sliderValue), preferredTimescale: 600)
        print()
        player?.seek(to: seekTime) { [weak self] completed in
            if completed {
                self?.output?.isThumbSeek = false
            }
        }
    }
    
    private func setupPeriodicTimeObserver() {
        let interval = CMTime(seconds: K.timeObserverInterval, preferredTimescale: 600)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] time in
            guard let self = self, let player = self.player else { return }
            
            let currentTime = CMTimeGetSeconds(player.currentTime())
            let totalTime = getDuration()
            
            self.output?.updateTime(currentTime: Float(currentTime), totalTime: Float(totalTime))
        })
    }
    
    func playVideo() {
        player?.play()
    }
    
    func pauseVideo() {
        player?.pause()
    }
    
    func getValuesPlayer() -> AVPlayer? {
        return player
    }
    
    func setMute(isMuted: Bool) {
        player?.isMuted = isMuted
    }
    
    func skip(forward: Bool) {
        let value = forward ? K.skipInterval : -K.skipInterval
        guard let currentTime = player?.currentTime() else { return }
        let seekTimeTen = CMTimeGetSeconds(currentTime).advanced(by: value)
        let seekTime = CMTime(seconds: seekTimeTen, preferredTimescale: 600)
        player?.seek(to: seekTime)
    }
    
    func getDuration() -> Float64 {
        guard let duration = player?.currentItem?.duration else { return 0.0 }
        return CMTimeGetSeconds(duration)
    }
    
    @objc private func videoDidFinishPlaying() {
        output?.videoDidFinishPlaying()
    }
    
    func replayVideo() {
        player?.seek(to: .zero)
        playVideo()
    }
    
    func setPlayRate(rate: Float) {
        player?.rate = rate
    }
    
    func fetchRemoteConfig() {
        Task {
            guard let config = await RemoteConfigManager().fetchRemoteConfig() else {
                print("[DEBUG] – Не удалось получить конфигурацию из Remote Config")
                output?.getRemoteConfig(nil)
                return
            }
            output?.getRemoteConfig(config)
        }
    }
}
