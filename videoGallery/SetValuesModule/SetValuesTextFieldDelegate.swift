//
//  SetValuesTextFieldDelegate.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.10.2024.
//

import Foundation

import UIKit

final class SetValuesTextFieldDelegate: NSObject, UITextFieldDelegate {
    private let presenter: SetValuesOutputProcotol
    
    init(presenter: SetValuesOutputProcotol) {
        self.presenter = presenter
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter.textFieldChanged(sender: textField)
        textField.resignFirstResponder()
        return true
    }
}
