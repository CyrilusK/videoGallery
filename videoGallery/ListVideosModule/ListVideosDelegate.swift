//
//  ListVideosDelegate.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.09.2024.
//

import UIKit

final class ListVideosDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let presenter: ListVideosOutputProtocol
    
    init(presenter: ListVideosOutputProtocol) {
        self.presenter = presenter
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectVideo(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width / 2) - 10
        return CGSize(width: size, height: size - 50)
    }
}
