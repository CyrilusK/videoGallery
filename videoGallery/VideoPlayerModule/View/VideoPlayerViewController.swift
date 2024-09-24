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
    
    lazy var currentContainerHeight: CGFloat = {
        CGFloat(config?.videoConstraintHeight ?? Float(view.frame.height / 3)) }()
    lazy var defaultHeight: CGFloat = {
        CGFloat(config?.videoConstraintHeight ?? Float(view.frame.height / 3)) }()
    
    private var playerLayer: AVPlayerLayer?
    private var videoPlayerHeightConstraint: NSLayoutConstraint!
    private var videoPlayerBottomConstraint: NSLayoutConstraint!
    private var config: VideoPlayerUIConfig?
    
    private let viewVideoPlayer = UIView()
    private let dimmedView = UIView()
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
            videoPlayerHeightConstraint.constant = defaultHeight
            fullScreenButton.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
        }
        else {
            videoPlayerHeightConstraint.constant = view.frame.width
            fullScreenButton.setImage(UIImage(systemName: "arrow.down.right.and.arrow.up.left"), for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.playerLayer?.frame = self.viewVideoPlayer.bounds
        })
    }
    
    /// Установка UI элементов
    func setConfigUI(config: VideoPlayerUIConfig) {
        self.config = config
    }
    
    func setupUI() {
        view.backgroundColor = .clear
        setupViewVideoPlayer()
        setupCenterControlsStackView()
        setupTimeLabels()
        setupTimeSlider()
        setupCloseButton()
        setupMuteButton()
        setupFullScreenButton()
        setupSpeedButtonAndControl()
    }
    
    func setupVideoPlayerLayer(player: AVPlayer?) {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resize
        guard let playerLayer = playerLayer else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + K.timeAnimate, execute: {
            playerLayer.frame = self.viewVideoPlayer.bounds
        })
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
        dimmedView.backgroundColor = .black
        viewVideoPlayer.backgroundColor = .black
        
        view.addSubview(dimmedView)
        view.addSubview(viewVideoPlayer)
        
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.translatesAutoresizingMaskIntoConstraints = false
        
        videoPlayerHeightConstraint = viewVideoPlayer.heightAnchor.constraint(equalToConstant: defaultHeight)
        videoPlayerBottomConstraint = viewVideoPlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: defaultHeight + view.safeAreaInsets.bottom)
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: viewVideoPlayer.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewVideoPlayer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewVideoPlayer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoPlayerHeightConstraint,
            videoPlayerBottomConstraint
        ])
        
        let tapGestureForDimmedView = UITapGestureRecognizer(target: self, action: #selector(animateDismissView))
        dimmedView.addGestureRecognizer(tapGestureForDimmedView)
        
        let tapGestureForVideoView = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        viewVideoPlayer.addGestureRecognizer(tapGestureForVideoView)
        
        setupPanGesture()
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragScreen(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        viewVideoPlayer.addGestureRecognizer(panGesture)
    }
    
    private func setupCenterControlsStackView() {
        setupPlayPauseButton()
        setupSkipButtons()
        centerControlsStackView.distribution = .fillProportionally
        centerControlsStackView.spacing = CGFloat(config?.buttonSpacing ?? 20)
        centerControlsStackView.axis = .horizontal
        centerControlsStackView.addArrangedSubview(skipBackwardButton)
        centerControlsStackView.addArrangedSubview(playPauseButton)
        centerControlsStackView.addArrangedSubview(skipForwardButton)
        centerControlsStackView.isHidden = !(config?.uiElementsVisibility["centerControlsStackView"] ?? true)
        centerControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(centerControlsStackView)
        NSLayoutConstraint.activate([
            centerControlsStackView.centerXAnchor.constraint(equalTo: viewVideoPlayer.centerXAnchor),
            centerControlsStackView.centerYAnchor.constraint(equalTo: viewVideoPlayer.centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35))
        ])
    }
    
    private func setupPlayPauseButton() {
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        playPauseButton.tintColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        playPauseButton.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playPauseButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            playPauseButton.heightAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35))
        ])
    }
    
    private func setupSkipButtons() {
        skipForwardButton.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        skipBackwardButton.setImage(UIImage(systemName: "gobackward.10"), for: .normal)
        skipForwardButton.tintColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        skipBackwardButton.tintColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        skipForwardButton.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        skipBackwardButton.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        skipForwardButton.addTarget(self, action: #selector(didTapSkipForward), for: .touchUpInside)
        skipBackwardButton.addTarget(self, action: #selector(didTapSkipBackward), for: .touchUpInside)
        skipForwardButton.translatesAutoresizingMaskIntoConstraints = false
        skipBackwardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipForwardButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            skipForwardButton.heightAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            skipBackwardButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            skipBackwardButton.heightAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35))
        ])
    }
    
    private func setupMuteButton() {
        muteButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        muteButton.tintColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        muteButton.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        muteButton.addTarget(self, action: #selector(didTapMute), for: .touchUpInside)
        muteButton.isHidden = !(config?.uiElementsVisibility["muteButton"] ?? true)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(muteButton)
        
        NSLayoutConstraint.activate([
            muteButton.topAnchor.constraint(equalTo: viewVideoPlayer.topAnchor, constant: 10),
            muteButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
            muteButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            muteButton.heightAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35))
        ])
    }
    
    private func setupTimeLabels() {
        currentTimeLabel.textColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        currentTimeLabel.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        currentTimeLabel.text = "00:00"
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(currentTimeLabel)
        
        totalTimeLabel.textColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        totalTimeLabel.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
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
        let isThumbCircleEnabled = config?.uiElementsVisibility["isThumbCircleEnabled"] ?? true
        timeSlider.minimumValue = 0
        timeSlider.setThumbImage(isThumbCircleEnabled ? UIImage(systemName: "circle.fill") : UIImage(), for: .normal)
        timeSlider.minimumTrackTintColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        timeSlider.maximumTrackTintColor = UIColor.fromNamedColor(config?.sliderColor ?? "lightgray")
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
        closeButton.tintColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        closeButton.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        closeButton.addTarget(self, action: #selector(animateDismissView), for: .touchUpInside)
        closeButton.isHidden = !(config?.uiElementsVisibility["closeButton"] ?? true)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: viewVideoPlayer.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: viewVideoPlayer.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            closeButton.heightAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35))
        ])
    }
    
    private func setupFullScreenButton() {
        fullScreenButton.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
        fullScreenButton.tintColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        fullScreenButton.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        fullScreenButton.addTarget(self, action: #selector(didTapFullScreen), for: .touchUpInside)
        fullScreenButton.isHidden = !(config?.uiElementsVisibility["fullScreenButton"] ?? true)
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(fullScreenButton)
        
        NSLayoutConstraint.activate([
            fullScreenButton.topAnchor.constraint(equalTo: viewVideoPlayer.topAnchor, constant: 10),
            fullScreenButton.leadingAnchor.constraint(equalTo: viewVideoPlayer.leadingAnchor, constant: 10),
            fullScreenButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            fullScreenButton.heightAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35))
        ])
    }
    
    private func setupSpeedButtonAndControl() {
        changeSpeedButton.setTitle("1.0x", for: .normal)
        changeSpeedButton.setTitleColor(UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white"), for: .normal)
        changeSpeedButton.translatesAutoresizingMaskIntoConstraints = false
        changeSpeedButton.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        changeSpeedButton.addTarget(self, action: #selector(didTapChangeSpeedButton), for: .touchUpInside)
        changeSpeedButton.isHidden = !(config?.uiElementsVisibility["changeSpeedButton"] ?? true)
        changeSpeedButton.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.addSubview(changeSpeedButton)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.fromNamedColor(config?.segmentedControlBackgroundColor ?? "white") as Any]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.fromNamedColor(config?.segmentedControlSelectedItemColor ?? "black") as Any]
        for (index, speed) in (config?.playbackSpeeds ?? [0.5, 1, 1.5, 2]).enumerated() {
            let title = "\(speed)x"
            speedSegmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        speedSegmentedControl.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        speedSegmentedControl.selectedSegmentTintColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        if let defaultIndex = config?.playbackSpeeds.firstIndex(of: 1.0) {
            speedSegmentedControl.selectedSegmentIndex = defaultIndex
        }
        speedSegmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        speedSegmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        speedSegmentedControl.addTarget(self, action: #selector(didChangeSpeed), for: .valueChanged)
        speedSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        speedSegmentedControl.isHidden = true
        viewVideoPlayer.addSubview(speedSegmentedControl)
        
        NSLayoutConstraint.activate([
            changeSpeedButton.topAnchor.constraint(equalTo: viewVideoPlayer.topAnchor, constant: 10),
            changeSpeedButton.leadingAnchor.constraint(equalTo: fullScreenButton.trailingAnchor, constant: 10),
            changeSpeedButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            changeSpeedButton.heightAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35))
        ])
        
        let count = Float(config?.playbackSpeeds.count ?? 4)
        NSLayoutConstraint.activate([
            speedSegmentedControl.topAnchor.constraint(equalTo: changeSpeedButton.bottomAnchor, constant: 10),
            speedSegmentedControl.leadingAnchor.constraint(equalTo: viewVideoPlayer.leadingAnchor, constant: 10),
            speedSegmentedControl.widthAnchor.constraint(equalToConstant: CGFloat(count * (config?.buttonSize ?? 35))),
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
        UIView.animate(withDuration: K.timeAnimate) {
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
        UIView.animate(withDuration: K.timeAnimate) {
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
    
    func getPlaybackSpeeds() -> [Float] {
        return config?.playbackSpeeds ?? [0.5, 1, 1.5, 2]
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: K.timeAnimate) {
            self.setVideoPlayerHeightConstraint(height)
        }
        currentContainerHeight = height
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: K.timeAnimate) {
            self.dimmedView.alpha = K.timeAnimate
        }
    }
    
    func animateShowVideoPlayerView() {
        UIView.animate(withDuration: K.timeAnimate) {
            self.setVideoPlayerBottomConstraint(0)
        }
    }
    
    func setVideoPlayerHeightConstraint(_ newHeight: CGFloat) {
        videoPlayerHeightConstraint.constant = newHeight
        view.layoutIfNeeded()
    }
    
    private func setVideoPlayerBottomConstraint(_ newBottom: CGFloat) {
        self.videoPlayerBottomConstraint.constant = newBottom
        self.view.layoutIfNeeded()
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
    
    @available(iOS 16.0, *)
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
    
    @objc private func didTapChangeSpeedButton() {
        speedSegmentedControl.isHidden.toggle()
        showControls()
    }
    
    @objc private func didChangeSpeed() {
        let selectedIndex = speedSegmentedControl.selectedSegmentIndex
        output?.didChangeSpeed(selectedIndex: selectedIndex)
        speedSegmentedControl.isHidden.toggle()
    }
    
    @objc private func didTapScreen() {
        showControls()
    }
    
    @objc private func didDragScreen(gesture: UIPanGestureRecognizer) {
        let maxHeight = view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        let translation = gesture.translation(in: view)
        output?.handleHeight(gesture, maxHeight, translation)
    }
    
    @objc func animateDismissView() {
        dimmedView.alpha = K.timeAnimate
        UIView.animate(withDuration: K.timeAnimate) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.output?.didClose()
        }
        UIView.animate(withDuration: K.timeAnimate) {
            self.setVideoPlayerBottomConstraint(self.defaultHeight)
        }
    }
}
