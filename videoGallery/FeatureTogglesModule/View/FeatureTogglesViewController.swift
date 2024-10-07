//
//  FeatureTogglesViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 30.09.2024.
//

import UIKit
import Firebase

final class FeatureTogglesViewController: UITableViewController, FeatureToggleViewInputProtocol {
    var output: FeatureToggleOutputProtocol?
    
    private var config: VideoPlayerUIConfig?
    private let resetButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.saveConfig(config: config)
    }
    
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = K.featureToggles
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.toggleCell)
        setupButtonReset()
    }
    
    func setConfigUI(config: VideoPlayerUIConfig?) {
        self.config = config
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupButtonReset() {
        resetButton.setImage(UIImage(systemName: "arrow.2.circlepath"), for: .normal)
        resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetButton)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return config?.uiElementsVisibility.keys.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.toggleCell, for: indexPath)
        guard let config = config else { return cell }
        
        let key = Array(config.uiElementsVisibility.keys.sorted())[indexPath.row]
        cell.textLabel?.text = key
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = config.uiElementsVisibility[key] ?? false
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged), for: .valueChanged)
        cell.accessoryView = toggleSwitch
        
        return cell
    }
    
    @objc func toggleSwitchChanged(_ sender: UISwitch) {
        guard let indexPath = tableView.indexPathForRow(at: sender.convert(sender.bounds.origin, to: tableView)),
                var config = config else { return }
        
        let key = Array(config.uiElementsVisibility.keys.sorted())[indexPath.row]
        config.uiElementsVisibility[key] = sender.isOn
        self.config = config
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc private func didTapReset() {
        output?.resetConfig()
    }
}
