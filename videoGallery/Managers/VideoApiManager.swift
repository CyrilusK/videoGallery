//
//  VideoApiManager.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.09.2024.
//

import UIKit

enum VideoApiError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return K.invalidURL
        case .noData:
            return K.noData
        case .decodingError(let error):
            return "\(K.decodingError) \(error)"
        case .networkError(let error):
            return "\(K.networkError) \(error)"
        case .serverError:
            return K.serverError
        }
    }
}

final class VideoApiManager {
//    let session: URLSession
//
//    init() {
//        let config = URLSessionConfiguration.default
//        config.protocolClasses?.insert(NetworkLogger.self, at: 0)
//        session = URLSession(configuration: config)
//    }
    
    func fetchVideos() async throws -> [Video] {
        guard let url = URL(string: K.urlAPI) else {
            NetworkLogger().logRequest(url: K.urlAPI, method: K.get, statusCode: 400)
            throw VideoApiError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                NetworkLogger().logRequest(url: url.absoluteString, method: K.get, statusCode: httpResponse.statusCode)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw VideoApiError.serverError
            }
            
            guard !data.isEmpty else {
                throw VideoApiError.noData
            }
            
            do {
                let videos = try JSONDecoder().decode([Video].self, from: data)
                return videos
            }
            catch let decodingError {
                throw VideoApiError.decodingError(decodingError)
            }
        }
        catch let networkError {
            NetworkLogger().logRequest(url: url.absoluteString, method: K.get, statusCode: 500)
            throw VideoApiError.networkError(networkError)
        }
    }
}
