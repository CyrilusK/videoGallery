//
//  FileManager.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

final class FileManager {
    private func documentsDirUrl() -> URL? {
        try? Foundation.FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
    }
    
    func saveLogsToFile<T: Encodable>(nameFile: String, logs: [T]) {
        guard let url = documentsDirUrl()?.appendingPathComponent(nameFile) else {
            print("[DEBUG] - failed to get documents dir url")
            return
        }
        print("[DEBUG] - \(url)")
        do {
            let data = try JSONEncoder().encode(logs)
            try data.write(to: url)
            print("[DEBUG] - Logs saved to \(url)")
        } catch {
            print("[DEBUG] - Failed to save logs: \(error.localizedDescription)")
        }
    }
    
    func loadLogsFromFile<T: Decodable>(nameFile: String, type: T.Type) -> [T]? {
        guard let url = documentsDirUrl()?.appendingPathComponent(nameFile) else {
            print("[DEBUG] - failed to get documents dir url")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let logs = try JSONDecoder().decode([T].self, from: data)
            print("[DEBUG] - Logs loaded from \(url)")
            return logs
        } catch {
            print("[DEBUG] - Failed to load logs: \(error.localizedDescription)")
            return nil
        }
    }
}
