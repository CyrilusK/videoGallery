//
//  VideoPlayerInteractorInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit
import AVKit

protocol VideoPlayerInteractorInputProtocol {
    func loadVideo(url: String)
    func seekToPosition(sliderValue: Float)
    func playVideo()
    func pauseVideo()
    func stopVideo()
    func getValuesPlayer() -> AVPlayer?
    func setMute(isMuted: Bool)
    func skip(forward: Bool)
    func getDuration() -> Float64
    func replayVideo()
    func setPlayRate(rate: Float)
    func fetchRemoteConfig() async
}
