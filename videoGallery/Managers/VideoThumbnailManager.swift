//
//  VideoThumbnailManager.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.09.2024.
//

import UIKit
import AVFoundation
import Firebase

//    private func generateThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
//        DispatchQueue.global().async {
//            let asset = AVAsset(url: url)
//            let imageGenerator = AVAssetImageGenerator(asset: asset)
//            imageGenerator.appliesPreferredTrackTransform = true
//
//            let time = CMTime(seconds: 5, preferredTimescale: 600)
//            do {
//                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
//                let image = UIImage(cgImage: cgImage)
//                completion(image)
//            } catch {
//                print("Error generating thumbnail: \(error.localizedDescription)")
//                completion(nil)
//            }
//        }
//    }

final class VideoThumbnailManager {
    func generateThumbnail(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 5, preferredTimescale: 600)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("[DEBUG] - Error generating thumbnail: \(error.localizedDescription)")
            Crashlytics.crashlytics().record(error: error)
            return nil
        }
    }
    
    func generateThumbnails(for videos: [Video]) async -> [UIImage?] {
        var result = Array<UIImage?>(repeating: nil, count: videos.count)
        
        await withTaskGroup(of: (Int, UIImage?).self) { [unowned self] group in
            for (index, video) in videos.enumerated() {
                if let url = URL(string: video.videoUrl) {
                    group.addTask {
                        let thumbnail = self.generateThumbnail(url: url)
                        return (index, thumbnail)
                    }
                }
            }
            for await (index, thumbnail) in group {
                result[index] = thumbnail
            }
        }
        return result
    }
}
