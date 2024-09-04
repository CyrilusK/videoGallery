//
//  VideoPlayerOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.09.2024.
//

import UIKit

protocol VideoPlayerOutputProtocol: AnyObject {
    func viewDidLoad()
    func getVideoURL() -> URL?
}
