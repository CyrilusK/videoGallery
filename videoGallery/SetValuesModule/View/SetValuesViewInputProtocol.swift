//
//  SetValuesViewInputProtocol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.10.2024.
//

import UIKit

protocol SetValuesViewInputProtocol: AnyObject {
    func setupUI()
    func updateTextFields(config: VideoPlayerUIConfig?)
    func textFieldChanged(sender: UITextField)
}
