//
//  ViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

final class ListVideosViewController: UIViewController, ListVideosViewInputProtocol {
    var output: ListVideosOutputProtocol?
    
    var videosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    func setupUI() {
        setupCollectionView()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.videosCollectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(videosCollectionView)
        videosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videosCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            videosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

