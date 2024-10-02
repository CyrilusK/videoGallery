//
//  SetValuesViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 02.10.2024.
//

import UIKit

final class SetValuesViewController: UIViewController, SetValuesViewInputProtocol {
    var output: SetValuesOutputProcotol?
    
    private let resetButton = UIButton()
    private var textFields: [(textField: UITextField, propertyName: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.saveConfig()
    }
    
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = K.setValues
        setupButtonReset()
        setupStackView()
    }
    
    private func setupButtonReset() {
        resetButton.setImage(UIImage(systemName: "arrow.2.circlepath"), for: .normal)
        resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetButton)
    }
    
    private func setupStackView() {
        textFields = [
            createTextField(placeholder: "Enter column count", propertyName: K.columnCount),
            createTextField(placeholder: "Enter video height", propertyName: K.videoConstraintHeight),
            createTextField(placeholder: "Enter button size", propertyName: K.buttonSize),
            createTextField(placeholder: "Enter button spacing", propertyName: K.buttonSpacing),
            createTextField(placeholder: K.enterColorName, propertyName: K.backgroundColor),
            createTextField(placeholder: K.enterColorName, propertyName: K.timeLabelTextColor),
            createTextField(placeholder: K.enterColorName, propertyName: K.labelBackgroundColor),
            createTextField(placeholder: K.enterColorName, propertyName: K.segmentBackgroundColor),
            createTextField(placeholder: K.enterColorName, propertyName: K.segmentSelectedItemColor),
            createTextField(placeholder: K.enterColorName, propertyName: K.sliderColor)
        ]
        
        let fieldsStackView = textFields.map { createRow(label: "\($0.propertyName):", control: $0.textField) }
        let stackView = UIStackView(arrangedSubviews: fieldsStackView)
        
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createRow(label: String, control: UIView) -> UIStackView {
        let labelView = UILabel()
        labelView.text = label
        let rowStackView = UIStackView(arrangedSubviews: [labelView, control])
        rowStackView.axis = .horizontal
        rowStackView.spacing = 10
        return rowStackView
    }
    
    private func createTextField(placeholder: String, propertyName: String) -> (UITextField, String) {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.delegate = output?.delegate as? UITextFieldDelegate
        textField.addTarget(self, action: #selector(textFieldChanged(sender:)), for: .editingDidEnd)
        return (textField, propertyName)
    }
    
    @objc private func didTapReset() {
        output?.resetConfig()
    }
    
    @objc func textFieldChanged(sender: UITextField) {
        guard let text = sender.text?.lowercased().trimmingCharacters(in: .whitespaces), !text.isEmpty else {
            sender.layer.borderColor = UIColor.red.cgColor
            sender.layer.borderWidth = 2.0
            return
        }

        if let index = textFields.firstIndex(where: { $0.textField == sender }) {
            let propertyName = textFields[index].propertyName
            
            if !(output?.validateInput(text: text, propertyName: propertyName) ?? false) {
                sender.layer.borderColor = UIColor.red.cgColor
                sender.layer.borderWidth = 2.0
                return
            }

            sender.layer.borderWidth = 0.0
            output?.updateConfig(text, propertyName)
        }
    }
    
    func updateTextFields(config: VideoPlayerUIConfig?) {
        guard let config = config else { return }
        let propertyMap = config.toDictionary()
        for (textField, propertyName) in textFields {
            textField.text = propertyMap[propertyName]
        }
    }
}
