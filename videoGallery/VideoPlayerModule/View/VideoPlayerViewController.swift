//
//  VideoPlayerViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.09.2024.
//

import UIKit
import AVKit

final class VideoPlayerViewController: UIViewController, VideoPlayerViewInputProtocol, VideoPlayerViewDelegate {
    var output: VideoPlayerOutputProtocol?
    
    private var playerLayer: AVPlayerLayer?
    private var containerHeightConstraint: NSLayoutConstraint!
    private var containerBottomConstraint: NSLayoutConstraint!
    private var videoViewHeightConstraint: NSLayoutConstraint!
    private var config: VideoPlayerUIConfig?
    
    private let containerView = UIView()
    private let viewVideoPlayer = VideoPlayerView()
    private let dimmedView = UIView()
    
    lazy var currentContainerHeight: CGFloat = {
        CGFloat(config?.videoConstraintHeight ?? Float(view.frame.height / 3)) }()
    lazy var defaultHeight: CGFloat = {
        CGFloat(config?.videoConstraintHeight ?? Float(view.frame.height / 3)) }()
    
    /// ЖЦ вьюконтроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        viewVideoPlayer.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output?.viewDidAppear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            let isPortrait = size.height > size.width
            if isPortrait {
                self.containerHeightConstraint.constant = self.defaultHeight
                self.videoViewHeightConstraint.constant = self.defaultHeight
                guard let image = UIImage(systemName: "arrow.up.left.and.arrow.down.right") else { return }
                self.viewVideoPlayer.setImageToFullScreen(image)
            } else {
                self.containerHeightConstraint.constant = self.view.frame.height
                self.videoViewHeightConstraint.constant = self.view.frame.height - self.view.safeAreaInsets.bottom
                guard let image = UIImage(systemName: "arrow.down.right.and.arrow.up.left") else { return }
                self.viewVideoPlayer.setImageToFullScreen(image)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.playerLayer?.frame = self.viewVideoPlayer.bounds
            }
        }, completion: nil)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            output?.presentDebug()
        }
    }
    
    /// Установка UI элементов
    func setConfigUI(config: VideoPlayerUIConfig) {
        self.config = config
        DispatchQueue.main.async {
            self.viewVideoPlayer.configure(with: config)
            self.setupViewVideoPlayer()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .clear
    }
    
    func setupVideoPlayerLayer(player: AVPlayer?) {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resize
        guard let playerLayer = playerLayer else {
            return
        }
        playerLayer.frame = self.viewVideoPlayer.bounds
        viewVideoPlayer.layer.addSublayer(playerLayer)
        viewVideoPlayer.bringUIElementsToFront()
    }
    
    private func setupViewVideoPlayer() {
        containerView.backgroundColor = UIColor.fromNamedColor(config?.backgroundColor ?? "white")
        dimmedView.backgroundColor = .black
        
        view.addSubview(containerView)
        view.addSubview(dimmedView)
        containerView.addSubview(viewVideoPlayer)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        viewVideoPlayer.translatesAutoresizingMaskIntoConstraints = false
        
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: defaultHeight + view.safeAreaInsets.bottom)
        videoViewHeightConstraint = viewVideoPlayer.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerHeightConstraint,
            containerBottomConstraint,
            
            viewVideoPlayer.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewVideoPlayer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewVideoPlayer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoViewHeightConstraint
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
        containerView.addGestureRecognizer(panGesture)
    }
    
    /// Функции для изменения состояний UI элементов
    func updatePlayPauseButton(isPlaying: Bool) {
        guard let buttonImage = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill") else {
            return
        }
        viewVideoPlayer.setImageToPlayPause(buttonImage)
    }

    func updateMuteButton(isMuted: Bool) {
        guard let muteImage = isMuted ? UIImage(systemName: "speaker.slash.fill") : UIImage(systemName: "speaker.wave.2.fill") else {
            return
        }
        viewVideoPlayer.setImageToMute(muteImage)
    }

    func updateTimeSlider(percent: Float) {
        viewVideoPlayer.updateTimeSlider(percent: percent)
    }

    func updateTimeLabels(currentTime: String, totalTime: String) {
        viewVideoPlayer.updateTimeLabels(currentTime: currentTime, totalTime: totalTime)
    }

    func hideControls() {
        viewVideoPlayer.hideControls()
    }

    func showControls() {
        viewVideoPlayer.showControls()
        output?.startHideControlsTimer()
    }

    func updatePlayPauseButtonToReplay() {
        guard let replayImage = UIImage(systemName: "memories") else {
            return
        }
        viewVideoPlayer.setImageToPlayPause(replayImage)
    }

    func updateTitleChangeSpeedButton(title: String) {
        viewVideoPlayer.updateTitleChangeSpeedButton(title: title)
    }

    func getPlaybackSpeeds() -> [Float] {
        return config?.playbackSpeeds ?? [0.5, 1, 1.5, 2]
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: K.timeAnimate) {
            self.setContainerHeightConstraint(height)
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
            self.setContainerBottomConstraint(0)
        }
    }
    
    func setContainerHeightConstraint(_ newHeight: CGFloat) {
        containerHeightConstraint.constant = newHeight
        view.layoutIfNeeded()
    }
    
    private func setContainerBottomConstraint(_ newBottom: CGFloat) {
        self.containerBottomConstraint.constant = newBottom
        self.view.layoutIfNeeded()
    }
    
    ///Обработчики нажатий
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
            self.setContainerBottomConstraint(self.defaultHeight)
        }
    }
    
    func didTapPlayPause() {
        output?.didTapPlayPause()
    }
    
    func didTapMute() {
        output?.didTapMute()
    }
    
    func didTapSkipForward() {
        output?.didTapSkipForward()
    }
    
    func didTapSkipBackward() {
        output?.didTapSkipBackward()
    }
    
    func didChangeSliderValue() {
        output?.didSeekToPosition(sliderValue: viewVideoPlayer.getTimeSliderValue())
    }
    
    func didTapСlose() {
        animateDismissView()
    }
    
    func didTapFullScreen() {
        if #available(iOS 16.0, *) {
            guard let windowScene = view.window?.windowScene else { return }
            
            if windowScene.interfaceOrientation == .portrait {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
                AnalyticsManager().logToggleVideoFullScreen(mode: K.fullscreen)
            } else {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                AnalyticsManager().logToggleVideoFullScreen(mode: K.normal)
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                AnalyticsManager().logToggleVideoFullScreen(mode: K.fullscreen)
            } else {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                AnalyticsManager().logToggleVideoFullScreen(mode: K.normal)
            }
        }
        showControls()
    }
    
    func didTapChangeSpeedButton() {
        viewVideoPlayer.speedSegmentedControlToggle()
        showControls()
    }
    
    func didChangeSpeed() {
        let selectedIndex = viewVideoPlayer.getSelectedSegmentIndex()
        output?.didChangeSpeed(selectedIndex: selectedIndex)
        viewVideoPlayer.speedSegmentedControlToggle()
    }
}
