//
//  ListVideosDataSource.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.09.2024.
//

import UIKit

final class ListVideosDataSource: NSObject, UICollectionViewDataSource  {
    private let presenter: ListVideosOutputProtocol
    
    init(presenter: ListVideosOutputProtocol) {
        self.presenter = presenter
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseIdentifier, for: indexPath) as? VideoCell else {
            return UICollectionViewCell()
        }
        let video = presenter.getVideo(at: indexPath)
        let thumbnail = presenter.getThumbnail(at: indexPath)
        cell.configure(with: video, thumbnail: thumbnail)
        return cell
    }
}
