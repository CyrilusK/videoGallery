//
//  VideoPlayerViewInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit
import AVKit

protocol VideoPlayerViewInputProtocol: AnyObject {
    func setupUI()
    func setupVideoPlayerLayer(player: AVPlayer?)
    func updatePlayPauseButton(isPlaying: Bool)
    func updateMuteButton(isMuted: Bool)
    func updateTimeSlider(percent: Float)
    func updateTimeLabels(currentTime: String, totalTime: String)
}
