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
        videoView.contentMode = .scaleToFill
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private let authorLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    func configure(with video: Video, thumbnail: UIImage?) {
        titleLabel.text = video.title
        durationLabel.text = video.duration
        authorLabel.text = video.author
        DispatchQueue.main.async {
            self.videoView.image = thumbnail
        }
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(videoView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: videoView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
            
            durationLabel.trailingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: -5),
            durationLabel.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -5),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoView.image = nil
    }
}
