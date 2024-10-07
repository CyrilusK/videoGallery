//
//  DebugOutputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 30.09.2024.
//

import UIKit

protocol DebugOutputProtocol: AnyObject {
    func viewDidLoad()
    func didSelectItem(at index: Int)
    func dismiss() 
}
