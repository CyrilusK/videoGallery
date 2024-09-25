//
//  VideoPlayerView.swift
//  videoGallery
//
//  Created by Cyril Kardash on 25.09.2024.
//

import UIKit

final class VideoPlayerView: UIView {
    weak var delegate: VideoPlayerViewDelegate?
    private var config: VideoPlayerUIConfig?
    
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
    
    func configure(with config: VideoPlayerUIConfig) {
        self.config = config
        setupUI()
    }
    
    ///Сетапы
    private func setupUI() {
        self.backgroundColor = .black
        setupCenterControlsStackView()
        setupTimeLabels()
        setupTimeSlider()
        setupCloseButton()
        setupMuteButton()
        setupFullScreenButton()
        setupSpeedButtonAndControl()
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
        self.addSubview(centerControlsStackView)
        NSLayoutConstraint.activate([
            centerControlsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centerControlsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
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
        self.addSubview(muteButton)
        
        NSLayoutConstraint.activate([
            muteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
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
        self.addSubview(currentTimeLabel)
        
        totalTimeLabel.textColor = UIColor.fromNamedColor(config?.timeLabelTextColor ?? "white")
        totalTimeLabel.backgroundColor = UIColor.fromNamedColor(config?.labelBackgroundColor ?? "black")?.withAlphaComponent(K.alphaComponent)
        totalTimeLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        totalTimeLabel.text = "00:00"
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(totalTimeLabel)
        
        NSLayoutConstraint.activate([
            currentTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            currentTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            totalTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            totalTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
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
        self.addSubview(timeSlider)
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
        closeButton.addTarget(self, action: #selector(didTapСlose), for: .touchUpInside)
        closeButton.isHidden = !(config?.uiElementsVisibility["closeButton"] ?? true)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
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
        self.addSubview(fullScreenButton)
        
        NSLayoutConstraint.activate([
            fullScreenButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            fullScreenButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
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
        self.addSubview(changeSpeedButton)
        
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
        self.addSubview(speedSegmentedControl)
        
        NSLayoutConstraint.activate([
            changeSpeedButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            changeSpeedButton.leadingAnchor.constraint(equalTo: fullScreenButton.trailingAnchor, constant: 10),
            changeSpeedButton.widthAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35)),
            changeSpeedButton.heightAnchor.constraint(equalToConstant: CGFloat(config?.buttonSize ?? 35))
        ])
        
        let count = Float(config?.playbackSpeeds.count ?? 4)
        NSLayoutConstraint.activate([
            speedSegmentedControl.topAnchor.constraint(equalTo: changeSpeedButton.bottomAnchor, constant: 10),
            speedSegmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            speedSegmentedControl.widthAnchor.constraint(equalToConstant: CGFloat(count * 45)),
            speedSegmentedControl.heightAnchor.constraint(equalTo: changeSpeedButton.widthAnchor)
        ])
    }
    
    ///Обработчики
    @objc private func didTapPlayPause() {
        delegate?.didTapPlayPause()
    }
    
    @objc private func didTapMute() {
        delegate?.didTapMute()
    }
    
    @objc private func didTapSkipForward() {
        delegate?.didTapSkipForward()
    }
    
    @objc private func didTapSkipBackward() {
        delegate?.didTapSkipBackward()
    }
    
    @objc private func didChangeSliderValue() {
        delegate?.didChangeSliderValue()
    }
    
    @objc private func didTapСlose() {
        delegate?.didTapСlose()
    }
    
    @objc private func didTapFullScreen() {
        delegate?.didTapFullScreen()
    }
    
    @objc private func didTapChangeSpeedButton() {
        delegate?.didTapChangeSpeedButton()
    }
    
    @objc private func didChangeSpeed() {
        delegate?.didChangeSpeed()
    }
    
    ///Функции для изменения состояний
    func setImageToPlayPause(_ image: UIImage) {
        playPauseButton.setImage(image, for: .normal)
    }
    
    func setImageToMute(_ image: UIImage) {
        muteButton.setImage(image, for: .normal)
    }
    
    func setImageToFullScreen(_ image: UIImage) {
        fullScreenButton.setImage(image, for: .normal)
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
    }
    
    func updateTitleChangeSpeedButton(title: String) {
        changeSpeedButton.setTitle(title, for: .normal)
    }
    
    func speedSegmentedControlToggle() {
        speedSegmentedControl.isHidden.toggle()
    }
    
    /// Функции для передачи значений UI элементов
    func getTimeSliderValue() -> Float {
        timeSlider.value
    }
    
    func getSelectedSegmentIndex() -> Int {
        speedSegmentedControl.selectedSegmentIndex
    }
}
