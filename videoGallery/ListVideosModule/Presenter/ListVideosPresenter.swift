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
    
    private var videos = [Video]()
    
    func viewDidLoad() {
        Task(priority: .userInitiated) {
            await interactor?.fetchVideos()
        }
        view?.setupUI()
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
    
    private func getVideo(at indexPath: IndexPath) -> Video {
        return videos[indexPath.row]
    }
    
    func didSelectVideo(at indexPath: IndexPath) {
        let video = getVideo(at: indexPath)
        router?.presentVideoDetail(video)
    }
}


