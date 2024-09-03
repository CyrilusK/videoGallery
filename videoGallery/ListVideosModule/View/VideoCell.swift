//
//  VideoCell.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.09.2024.
//

import UIKit
import AVFoundation

final class VideoCell: UICollectionViewCell {
    
    private let videoView: UIImageView = {
        let videoView = UIImageView()
        videoView.contentMode = .scaleAspectFit
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    func configure(with video: Video, thumbnail: UIImage?) {
        titleLabel.text = video.title
        durationLabel.text = video.duration
        DispatchQueue.main.async {
            self.videoView.image = thumbnail
        }
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(videoView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35),
            
            titleLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            durationLabel.trailingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: -10),
            durationLabel.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -5),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoView.image = nil
    }
}
