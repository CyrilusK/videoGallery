//
//  VideoPlayerOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit

protocol VideoPlayerOutputProtocol: AnyObject {
    var isThumbSeek: Bool { get set }
    
    func viewDidLoad()
    func viewDidAppear()
    func didTapPlayPause()
    func didTapMute()
    func didTapSkipForward()
    func didTapSkipBackward()
    func didSeekToPosition(sliderValue: Float)
    func updateTime(currentTime: Float, totalTime: Float)
    func getFormattedDuration() -> String
}
