//
//  VideoPlayerViewInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit

protocol VideoPlayerViewInputProtocol: AnyObject {
    func setupUI()
    func setupVideoPlayer()
    func playVideo()
    func pauseVideo()
}
