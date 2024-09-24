//
//  VideoPlayerViewInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit
import AVKit

protocol VideoPlayerViewInputProtocol: AnyObject {
    var currentContainerHeight: CGFloat { get }
    var defaultHeight: CGFloat { get }
    
    func setupUI()
    func setupVideoPlayerLayer(player: AVPlayer?)
    func updatePlayPauseButton(isPlaying: Bool)
    func updateMuteButton(isMuted: Bool)
    func updateTimeSlider(percent: Float)
    func updateTimeLabels(currentTime: String, totalTime: String)
    func hideControls()
    func showControls()
    func updatePlayPauseButtonToReplay()
    func updateTitleChangeSpeedButton(title: String)
    func setConfigUI(config: VideoPlayerUIConfig)
    func getPlaybackSpeeds() -> [Float]
    func animateContainerHeight(_ height: CGFloat)
    func setVideoPlayerHeightConstraint(_ newHeight: CGFloat)
    func animateDismissView()
    func animateShowDimmedView()
}
