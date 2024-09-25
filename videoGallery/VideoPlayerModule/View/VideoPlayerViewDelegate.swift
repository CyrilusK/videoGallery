//
//  VideoPlayerViewDelegate.swift
//  videoGallery
//
//  Created by Cyril Kardash on 25.09.2024.
//

import Foundation

protocol VideoPlayerViewDelegate: AnyObject {
    func didTapPlayPause()
    func didTapMute()
    func didTapSkipForward()
    func didTapSkipBackward()
    func didChangeSliderValue()
    func didTapСlose()
    func didTapFullScreen()
    func didTapChangeSpeedButton()
    func didChangeSpeed()
}
