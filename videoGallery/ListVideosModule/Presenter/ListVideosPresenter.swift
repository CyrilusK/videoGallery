//
//  ListVideosPresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

final class ListVideosPresenter: ListVideosOutputProtocol {
    weak var view: ListVideosViewInputProtocol?
    var interactor: ListVideosInteractorInputProtocol?
    var router: ListVideosRouterInputProtocol?
    
    var videos = [Video]()
    var thumbnails = [UIImage?]()
    var config: VideoPlayerUIConfig?
    
    var dataSource: UICollectionViewDataSource?
    var delegate: UICollectionViewDelegate?
    
    init() {
        self.dataSource = ListVideosDataSource(presenter: self)
        self.delegate = ListVideosDelegate(presenter: self)
    }
    
    func viewDidLoad() {
        Task(priority: .userInitiated) {
            await interactor?.fetchRemoteConfig()
            await interactor?.fetchVideos()
            guard let arrayThumbnails = await self.interactor?.getThumbnails(for: self.videos) else {
                return
            }
            thumbnails = arrayThumbnails
            DispatchQueue.main.async {
                self.view?.setupUI()
            }
        }
        view?.setupIndicator()
    }
    
    func didFetchVideos(_ videos: [Video]) {
        self.videos = videos
        view?.reloadData()
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            if let error = error as? VideoApiError {
                self.view?.displayError("Failed to load videos: \(error.errorDescription)")
            } else {
                self.view?.displayError("Failed to load videos: \(error.localizedDescription)")
            }
        }
    }
    
    func getVideo(at indexPath: IndexPath) -> Video {
        return videos[indexPath.row]
    }
    
    func getThumbnail(at indexPath: IndexPath) -> UIImage? {
        guard indexPath.row < thumbnails.count else {
            return nil
        }
        return thumbnails[indexPath.row]
    }
    
    func didSelectVideo(at indexPath: IndexPath) {
        let video = getVideo(at: indexPath)
        router?.presentVideoDetail(video)
    }
    
    func getRemoteConfig(_ config: VideoPlayerUIConfig) {
        self.config = config
    }
}


