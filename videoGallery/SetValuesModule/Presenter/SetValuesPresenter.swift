//
//  SetValuesPresenter.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.10.2024.
//

import UIKit

final class SetValuesPresenter: SetValuesOutputProcotol {
    weak var view: SetValuesViewInputProtocol?
    var interactor: SetValuesInteractorInputProtocol?
    var delegate: UITextFieldDelegate?
    
    private var config: VideoPlayerUIConfig?
    
    init() {
        delegate = SetValuesTextFieldDelegate(presenter: self)
    }
    
    func viewDidLoad() {
        interactor?.fetchRemoteConfig()
        view?.setupUI()
    }
    
    func saveConfig() {
        interactor?.saveConfig(config: config)
    }
    
    func resetConfig() {
        interactor?.resetConfig()
    }
    
    func setConfigUI(_ config: VideoPlayerUIConfig?) {
        self.config = config
        DispatchQueue.main.async {
            self.view?.updateTextFields(config: config)
        }
    }
    
    func validateInput(text: String, propertyName: String) -> Bool {
        let isNumeric = Double(text) != nil
        let isColorName = UIColor.fromNamedColor(text) != nil
        return isNumeric || isColorName
    }
    
    func updateConfig(_ text: String,_ propertyName: String) {
        switch propertyName {
        case K.columnCount:
            config?.cellCount = Int(text) ?? 0
        case K.videoConstraintHeight:
            config?.videoConstraintHeight = Float(text) ?? 250
        case K.buttonSize:
            config?.buttonSize = Float(text) ?? 35
        case K.buttonSpacing:
            config?.buttonSpacing = Float(text) ?? 50
        case K.backgroundColor:
            config?.backgroundColor = text
        case K.timeLabelTextColor:
            config?.timeLabelTextColor = text
        case K.labelBackgroundColor:
            config?.labelBackgroundColor = text
        case K.segmentBackgroundColor:
            config?.segmentedControlBackgroundColor = text
        case K.segmentSelectedItemColor:
            config?.segmentedControlSelectedItemColor = text
        case K.sliderColor:
            config?.sliderColor = text
        default:
            break
        }
    }
    
    func textFieldChanged(sender: UITextField) {
        view?.textFieldChanged(sender: sender)
    }
}

