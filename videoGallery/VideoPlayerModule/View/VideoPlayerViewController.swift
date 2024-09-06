//
//  VideoPlayerViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.09.2024.
//

import UIKit
import AVKit

final class VideoPlayerViewController: UIViewController, VideoPlayerViewInputProtocol {
    var output: VideoPlayerOutputProtocol?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private let viewVideoPlayer = UIView()
    private let centerControlsStackView = UIStackView()
    private let playPauseButton = UIButton(type: .system)
    private let muteButton = UIButton(type: .system)
    private let skipForwardButton = UIButton(type: .system)
    private let skipBackwardButton = UIButton(type: .system)
    private let timeSlider = UISlider()
    private let currentTimeLabel = UILabel()
    private let totalTimeLabel = UILabel()
    
    private var isThumbseek = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output?.viewDidAppear()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            viewVideoPlayer.constraints.last?.constant = view.frame.width / 3
        }
        else {
            viewVideoPlayer.constraints.last?.constant = view.frame.width
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.playerLayer?.frame = self.viewVideoPlayer.bounds
        })
    }
    
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        setupViewVideoPlayer()
        setupCenterControlsStackView()
        setupMuteButton()
        setupTimeLabels()
        setupTimeSlider()
    }
    
    func setupVideoPlayer() {
        guard let url = output?.getVideoURL() else {
            return
        }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        guard let playerLayer = playerLayer else {
            return
        }
        playerLayer.frame = viewVideoPlayer.bounds
        viewVideoPlayer.layer.addSublayer(playerLayer)
        viewVideoPlayer.layer.addSublayer(centerControlsStackView.layer)
        viewVideoPlayer.layer.addSublayer(currentTimeLabel.layer)
        viewVideoPlayer.layer.addSublayer(totalTimeLabel.layer)
        viewVideoPlayer.layer.addSublayer(timeSlider.layer)
        addPeriodicTimeObserver()
        playVideo()
    }
    
    private func setupViewVideoPlayer() {
        viewVideoPlayer.backgroundColor = .black
        viewVideoPlayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewVideoPlayer)
        NSLayoutConstraint.activate([
            viewVideoPlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewVideoPlayer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewVideoPlayer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            viewVideoPlayer.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
    }
    
    private func setupCenterControlsStackView() {
        setupPlayPauseButton()
        setupSkipButtons()
        centerControlsStackView.distribution = .fillProportionally
        centerControlsStackView.spacing = 20
        centerControlsStackView.axis = .horizontal
        centerControlsStackView.addArrangedSubview(skipBackwardButton)
        centerControlsStackView.addArrangedSubview(playPauseButton)
        centerControlsStackView.addArrangedSubview(skipForwardButton)
        centerControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(centerControlsStackView)
        NSLayoutConstraint.activate([
            centerControlsStackView.centerXAnchor.constraint(equalTo: viewVideoPlayer.centerXAnchor),
            centerControlsStackView.centerYAnchor.constraint(equalTo: viewVideoPlayer.centerYAnchor)
        ])
    }
    
    private func setupPlayPauseButton() {
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        playPauseButton.tintColor = .white
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSkipButtons() {
        skipForwardButton.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        skipBackwardButton.setImage(UIImage(systemName: "gobackward.10"), for: .normal)
        skipForwardButton.tintColor = .white
        skipBackwardButton.tintColor = .white
        skipForwardButton.addTarget(self, action: #selector(didTapSkipForward), for: .touchUpInside)
        skipBackwardButton.addTarget(self, action: #selector(didTapSkipBackward), for: .touchUpInside)
        skipForwardButton.translatesAutoresizingMaskIntoConstraints = false
        skipBackwardButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func didTapSkipForward() {
        guard let currentTime = player?.currentTime() else { return }
        let seekTimeTen = CMTimeGetSeconds(currentTime).advanced(by: 10)
        let seekTime = CMTime(seconds: seekTimeTen, preferredTimescale: 600)
        player?.seek(to: seekTime)
    }
    
    @objc private func didTapSkipBackward() {
        guard let currentTime = player?.currentTime() else { return }
        let seekTimeTen = CMTimeGetSeconds(currentTime).advanced(by: -10)
        let seekTime = CMTime(seconds: seekTimeTen, preferredTimescale: 600)
        player?.seek(to: seekTime)
    }
    
    private func setupMuteButton() {
        muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        muteButton.tintColor = .white
        //muteButton.addTarget(self, action: #selector(didTapMute), for: .touchUpInside)
    }
    
    private func setupTimeLabels() {
        currentTimeLabel.textColor = .white
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        currentTimeLabel.text = "00:00"
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(currentTimeLabel)
        
        totalTimeLabel.textColor = .white
        totalTimeLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        totalTimeLabel.text = output!.getVideo().duration
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(totalTimeLabel)
        
        NSLayoutConstraint.activate([
            currentTimeLabel.bottomAnchor.constraint(equalTo: viewVideoPlayer.bottomAnchor, constant: -5),
            currentTimeLabel.leadingAnchor.constraint(equalTo: viewVideoPlayer.leadingAnchor, constant: 5),
            
            totalTimeLabel.bottomAnchor.constraint(equalTo: viewVideoPlayer.bottomAnchor, constant: -5),
            totalTimeLabel.trailingAnchor.constraint(equalTo: viewVideoPlayer.trailingAnchor, constant: -5)
        ])
    }
    
    private func setupTimeSlider() {
        timeSlider.minimumValue = 0
        //timeSlider.setThumbImage(UIImage(), for: .normal)
        timeSlider.minimumTrackTintColor = .white
        timeSlider.maximumTrackTintColor = .lightGray
        timeSlider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(timeSlider)
        NSLayoutConstraint.activate([
            timeSlider.centerYAnchor.constraint(equalTo: currentTimeLabel.centerYAnchor),
            timeSlider.trailingAnchor.constraint(equalTo: totalTimeLabel.leadingAnchor, constant: -3),
            timeSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: 3)
        ])
    }
    
    @objc private func didChangeSliderValue() {
        guard let duration = player?.currentItem?.duration else { return }
        isThumbseek = true
        let totalTime = CMTimeGetSeconds(duration)
        let value = totalTime * Float64(timeSlider.value)
        let seekTime = CMTime(seconds: value, preferredTimescale: 600)
        player?.seek(to: seekTime, completionHandler: { completed in
            if completed {
                self.isThumbseek = false
            }
        })
    }
    
    func playVideo() {
        player?.play()
    }
    
    func pauseVideo() {
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        player?.pause()
    }
    
    @objc private func didTapPlayPause() {
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        output?.didTapPlayPause()
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.3, preferredTimescale: 600)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] time in
            guard let self = self, let player = self.player, let currentItem = player.currentItem else { return }
            
            let currentTime = CMTimeGetSeconds(player.currentTime())
            let totalTime = CMTimeGetSeconds(currentItem.duration)
            
            if !isThumbseek {
                self.timeSlider.value = Float(currentTime / totalTime)
            }
            self.currentTimeLabel.text = self.output?.formatTime(seconds: currentTime)
            self.totalTimeLabel.text = self.output?.formatTime(seconds: totalTime)
        })
    }
}
