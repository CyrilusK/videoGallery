//
//  ListVideosInteractor.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit
import Firebase

final class ListVideosInteractor: ListVideosInteractorInputProtocol {
    weak var output: ListVideosOutputProtocol?
    
    func fetchVideos() async {
        do {
            let videos = try await VideoApiManager().fetchVideos()
            output?.didFetchVideos(videos)
        }
        catch {
            output?.showError(error)
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    func getThumbnails(for videos: [Video]) async -> [UIImage?] {
        await VideoThumbnailManager().generateThumbnails(for: videos)
    }
    
    func fetchRemoteConfig() async {
        guard let config = await RemoteConfigManager.shared.fetchRemoteConfig() else {
            print("[DEBUG] – Не удалось получить конфигурацию из Remote Config")
            return
        }
        output?.getRemoteConfig(config)
    }
}
