//
//  VideoPlayerOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit
import AVKit

protocol VideoPlayerOutputProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func getVideoURL() -> URL?
    func getVideo() -> Video
    func didTapPlayPause()
    func formatTime(seconds: Double) -> String
}
