//
//  ListVideosInteractor.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

final class ListVideosInteractor: ListVideosInteractorInputProtocol {
    weak var output: ListVideosOutputProtocol?
    
    func fetchVideos() async {
        do {
            let videos = try await VideoApiManager().fetchVideos()
            output?.didFetchVideos(videos)
        }
        catch {
            output?.showError(error)
        }
    }
}
