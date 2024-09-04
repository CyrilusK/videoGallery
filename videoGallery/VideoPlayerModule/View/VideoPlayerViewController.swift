//
//  VideoPlayerViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.09.2024.
//

import UIKit
import AVKit

final class VideoPlayerViewController: UIViewController, VideoPlayerViewInputProtocol, AVPlayerViewControllerDelegate {
    var output: VideoPlayerOutputProtocol?
    private var player: AVPlayer?
    private var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    func setupVideoPlayer(with video: Video) {
        guard let url = output?.getVideoURL() else {
            return
        }
        player = AVPlayer(url: url)
        playerController = AVPlayerViewController()
        playerController.player = player
        playerController.delegate = self
        
        addChild(playerController)
        playerController.view.frame = view.bounds
        view.addSubview(playerController.view)
        playerController.didMove(toParent: self)
        
        playerController.player?.play()
    }
}
