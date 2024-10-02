//
//  SetValuesOutputProcotol.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.10.2024.
//

import UIKit

protocol SetValuesOutputProcotol: AnyObject {
    var delegate: UITextFieldDelegate? { get set }
    
    func viewDidLoad()
    func saveConfig()
    func resetConfig()
    func setConfigUI(_ config: VideoPlayerUIConfig?)
    func validateInput(text: String, propertyName: String) -> Bool
    func updateConfig(_ text: String, _ propertyName: String)
    func textFieldChanged(sender: UITextField)
}
