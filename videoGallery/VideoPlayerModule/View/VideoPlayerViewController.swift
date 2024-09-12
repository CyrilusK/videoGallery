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
    private var videoPlayerHeightConstraint: NSLayoutConstraint?
    
    private let viewVideoPlayer = UIView()
    private let centerControlsStackView = UIStackView()
    private let playPauseButton = UIButton(type: .system)
    private let muteButton = UIButton(type: .system)
    private let skipForwardButton = UIButton(type: .system)
    private let skipBackwardButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let fullScreenButton = UIButton(type: .system)
    private let changeSpeedButton = UIButton(type: .system)
    private let timeSlider = UISlider()
    private let currentTimeLabel = UILabel()
    private let totalTimeLabel = UILabel()
    private let speedSegmentedControl = UISegmentedControl()
    
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
        
        guard let windowInterface = self.view.window?.windowScene?.interfaceOrientation else { return }
        if windowInterface.isPortrait {
            videoPlayerHeightConstraint?.constant = viewVideoPlayer.frame.width / 3
            fullScreenButton.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
        }
        else {
            videoPlayerHeightConstraint?.constant = viewVideoPlayer.frame.width
            fullScreenButton.setImage(UIImage(systemName: "arrow.down.right.and.arrow.up.left"), for: .normal)
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
        setupTimeLabels()
        setupTimeSlider()
        setupCloseButton()
        setupMuteButton()
        setupFullScreenButton()
    }
    
    func setupVideoPlayerLayer(player: AVPlayer?) {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resize
        guard let playerLayer = playerLayer else {
            return
        }
        playerLayer.frame = viewVideoPlayer.bounds
        viewVideoPlayer.layer.addSublayer(playerLayer)
        viewVideoPlayer.layer.addSublayer(centerControlsStackView.layer)
        viewVideoPlayer.layer.addSublayer(currentTimeLabel.layer)
        viewVideoPlayer.layer.addSublayer(totalTimeLabel.layer)
        viewVideoPlayer.layer.addSublayer(timeSlider.layer)
        viewVideoPlayer.layer.addSublayer(closeButton.layer)
        viewVideoPlayer.layer.addSublayer(muteButton.layer)
        viewVideoPlayer.layer.addSublayer(fullScreenButton.layer)
        viewVideoPlayer.layer.addSublayer(changeSpeedButton.layer)
        viewVideoPlayer.layer.addSublayer(speedSegmentedControl.layer)
    }
    
    private func setupViewVideoPlayer() {
        viewVideoPlayer.backgroundColor = .black
        viewVideoPlayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewVideoPlayer)
        
        videoPlayerHeightConstraint = viewVideoPlayer.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        
        NSLayoutConstraint.activate([
            viewVideoPlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewVideoPlayer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewVideoPlayer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoPlayerHeightConstraint!
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        viewVideoPlayer.addGestureRecognizer(tapGestureRecognizer)
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
        playPauseButton.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSkipButtons() {
        skipForwardButton.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        skipBackwardButton.setImage(UIImage(systemName: "gobackward.10"), for: .normal)
        skipForwardButton.tintColor = .white
        skipBackwardButton.tintColor = .white
        skipForwardButton.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        skipBackwardButton.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        skipForwardButton.addTarget(self, action: #selector(didTapSkipForward), for: .touchUpInside)
        skipBackwardButton.addTarget(self, action: #selector(didTapSkipBackward), for: .touchUpInside)
        skipForwardButton.translatesAutoresizingMaskIntoConstraints = false
        skipBackwardButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupMuteButton() {
        muteButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        muteButton.tintColor = .white
        muteButton.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        muteButton.addTarget(self, action: #selector(didTapMute), for: .touchUpInside)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(muteButton)
        
        NSLayoutConstraint.activate([
            muteButton.topAnchor.constraint(equalTo: viewVideoPlayer.topAnchor, constant: 10),
            muteButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
            muteButton.heightAnchor.constraint(equalTo: closeButton.heightAnchor),
            muteButton.widthAnchor.constraint(equalTo: closeButton.widthAnchor)
        ])
    }
    
    private func setupTimeLabels() {
        currentTimeLabel.textColor = .white
        currentTimeLabel.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        currentTimeLabel.text = "00:00"
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(currentTimeLabel)
        
        totalTimeLabel.textColor = .white
        totalTimeLabel.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        totalTimeLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        totalTimeLabel.text = output?.getFormattedDuration()
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(totalTimeLabel)
        
        NSLayoutConstraint.activate([
            currentTimeLabel.bottomAnchor.constraint(equalTo: viewVideoPlayer.bottomAnchor, constant: -8),
            currentTimeLabel.leadingAnchor.constraint(equalTo: viewVideoPlayer.leadingAnchor, constant: 5),
            
            totalTimeLabel.bottomAnchor.constraint(equalTo: viewVideoPlayer.bottomAnchor, constant: -8),
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
    
    private func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: viewVideoPlayer.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: viewVideoPlayer.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupFullScreenButton() {
        fullScreenButton.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
        fullScreenButton.tintColor = .white
        fullScreenButton.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        fullScreenButton.addTarget(self, action: #selector(didTapFullScreen), for: .touchUpInside)
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(fullScreenButton)
        
        NSLayoutConstraint.activate([
            fullScreenButton.topAnchor.constraint(equalTo: viewVideoPlayer.topAnchor, constant: 10),
            fullScreenButton.leadingAnchor.constraint(equalTo: viewVideoPlayer.leadingAnchor, constant: 10),
            fullScreenButton.heightAnchor.constraint(equalTo: closeButton.heightAnchor),
            fullScreenButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor)
        ])
    }
    
    private func setupSpeedButtonAndControl() {
        changeSpeedButton.setTitle("1.0x", for: .normal)
        changeSpeedButton.setTitleColor(.white, for: .normal)
        changeSpeedButton.translatesAutoresizingMaskIntoConstraints = false
        changeSpeedButton.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        changeSpeedButton.addTarget(self, action: #selector(didTapChangeSpeedButton), for: .touchUpInside)
        changeSpeedButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(changeSpeedButton)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        speedSegmentedControl.insertSegment(withTitle: "0.5x", at: 0, animated: false)
        speedSegmentedControl.insertSegment(withTitle: "1.0x", at: 1, animated: false)
        speedSegmentedControl.insertSegment(withTitle: "1.5x", at: 2, animated: false)
        speedSegmentedControl.insertSegment(withTitle: "2.0x", at: 3, animated: false)
        speedSegmentedControl.backgroundColor = UIColor.black.withAlphaComponent(K.alphaComponent)
        speedSegmentedControl.selectedSegmentTintColor = .white
        speedSegmentedControl.selectedSegmentIndex = 1
        speedSegmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        speedSegmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        speedSegmentedControl.addTarget(self, action: #selector(didChangeSpeed), for: .valueChanged)
        speedSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        speedSegmentedControl.isHidden = true
        viewVideoPlayer.addSubview(speedSegmentedControl)
        
        NSLayoutConstraint.activate([
            changeSpeedButton.topAnchor.constraint(equalTo: viewVideoPlayer.topAnchor, constant: 10),
            changeSpeedButton.leadingAnchor.constraint(equalTo: fullScreenButton.trailingAnchor, constant: 10),
            changeSpeedButton.heightAnchor.constraint(equalTo: fullScreenButton.heightAnchor),
            changeSpeedButton.widthAnchor.constraint(equalTo: fullScreenButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            speedSegmentedControl.topAnchor.constraint(equalTo: changeSpeedButton.bottomAnchor, constant: 10),
            speedSegmentedControl.leadingAnchor.constraint(equalTo: viewVideoPlayer.leadingAnchor, constant: 10),
            speedSegmentedControl.widthAnchor.constraint(equalToConstant: 4 * 40),
            speedSegmentedControl.heightAnchor.constraint(equalTo: changeSpeedButton.widthAnchor)
        ])
    }
    
    func updatePlayPauseButton(isPlaying: Bool) {
        let buttonImage = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
        playPauseButton.setImage(buttonImage, for: .normal)
    }
    
    func updateMuteButton(isMuted: Bool) {
        let muteImage = isMuted ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.wave.2.fill")
        muteButton.setImage(muteImage, for: .normal)
    }
    
    func updateTimeSlider(percent: Float) {
        timeSlider.value = percent
    }
    
    func updateTimeLabels(currentTime: String, totalTime: String) {
        currentTimeLabel.text = currentTime
        totalTimeLabel.text = totalTime
    }
    
    func hideControls() {
        UIView.animate(withDuration: 0.5) {
            self.centerControlsStackView.alpha = 0
            self.muteButton.alpha = 0
            self.closeButton.alpha = 0
            self.fullScreenButton.alpha = 0
            self.timeSlider.alpha = 0
            self.currentTimeLabel.alpha = 0
            self.totalTimeLabel.alpha = 0
            self.changeSpeedButton.alpha = 0
            self.speedSegmentedControl.alpha = 0
        }
    }
    
    func showControls() {
        UIView.animate(withDuration: 0.5) {
            self.centerControlsStackView.alpha = 1
            self.muteButton.alpha = 1
            self.closeButton.alpha = 1
            self.fullScreenButton.alpha = 1
            self.timeSlider.alpha = 1
            self.currentTimeLabel.alpha = 1
            self.totalTimeLabel.alpha = 1
            self.changeSpeedButton.alpha = 1
            self.speedSegmentedControl.alpha = 1
        }
        output?.startHideControlsTimer()
    }
    
    func updatePlayPauseButtonToReplay() {
        playPauseButton.setImage(UIImage(systemName: "memories"), for: .normal)
    }
    
    func updateTitleChangeSpeedButton(title: String) {
        changeSpeedButton.setTitle(title, for: .normal)
    }
    
    func checkSpeedControlFeature(isEnabled: Bool) {
        setupSpeedButtonAndControl()
        changeSpeedButton.isHidden = !isEnabled
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
    
    @objc private func didTapClose() {
        output?.didClose()
    }
    
    @objc private func didTapFullScreen() {
        guard let windowScene = view.window?.windowScene else { return }
        
        if windowScene.interfaceOrientation == .portrait {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
            AnalyticsManager().logToggleVideoFullScreen(mode: K.fullscreen)
        }
        else {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            AnalyticsManager().logToggleVideoFullScreen(mode: K.normal)
        }
        showControls()
    }
    
    @objc private func didTapScreen() {
        showControls()
    }
    
    @objc private func didTapChangeSpeedButton() {
        speedSegmentedControl.isHidden.toggle()
        showControls()
    }
    
    @objc private func didChangeSpeed() {
        let selectedIndex = speedSegmentedControl.selectedSegmentIndex
        output?.didChangeSpeed(selectedIndex: selectedIndex)
        speedSegmentedControl.isHidden.toggle()
    }
}
