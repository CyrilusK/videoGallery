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
    
    /// ЖЦ вьюконтроллера
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
    
    /// Установка UI элементов
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        setupViewVideoPlayer()
        setupCenterControlsStackView()
        setupMuteButton()
        setupTimeLabels()
        setupTimeSlider()
    }
    
    func setupVideoPlayerLayer(player: AVPlayer?) {
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
    
    private func setupMuteButton() {
        muteButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        muteButton.tintColor = .white
        muteButton.addTarget(self, action: #selector(didTapMute), for: .touchUpInside)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(muteButton)
    }
    
    private func setupTimeLabels() {
        currentTimeLabel.textColor = .white
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        currentTimeLabel.text = "00:00"
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(currentTimeLabel)
        
        totalTimeLabel.textColor = .white
        totalTimeLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        totalTimeLabel.text = output?.getFormattedDuration()
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
        timeSlider.setThumbImage(UIImage(), for: .normal)
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
    
    func updatePlayPauseButton(isPlaying: Bool) {
        let buttonImage = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
        playPauseButton.setImage(buttonImage, for: .normal)
    }
    
    func updateMuteButton(isMuted: Bool) {
        let muteImage = isMuted ? UIImage(systemName: "speaker.wave.2.fill") : UIImage(systemName: "speaker.slash.fill")
        muteButton.setImage(muteImage, for: .normal)
    }
    
    func updateTimeSlider(percent: Float) {
        timeSlider.value = percent
    }
    
    func updateTimeLabels(currentTime: String, totalTime: String) {
        currentTimeLabel.text = currentTime
        totalTimeLabel.text = totalTime
    }
    
    ///Обработчики нажатий
    @objc private func didTapPlayPause() {
        output?.didTapPlayPause()
    }
    
    @objc private func didTapMute() {
        output?.didTapMute()
    }
    
    @objc private func didTapSkipForward() {
        output?.didTapSkipForward()
    }
    
    @objc private func didTapSkipBackward() {
        output?.didTapSkipBackward()
    }
    
    @objc private func didChangeSliderValue() {
        output?.didSeekToPosition(sliderValue: timeSlider.value)
    }
}
