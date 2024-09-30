//
//  DebugViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 30.09.2024.
//

import UIKit

final class DebugViewController: UITableViewController, DebugViewInputProtocol {
    var output: DebugOutputProtocol?
    
    private let closeButton = UIButton(type: .close)
    private let items = ["🚩 Feature toggles", "❌ Краши (fatal ошибки)", "⚠️ Unfatal ошибки", "💬 Логирование"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let device = UIDevice.current
        return "Build: \(Bundle.main.infoDictionary?[K.CFBundleVersion] as? String ?? "N/A"), Device: \(device.model) - \(device.systemName) \(device.systemVersion)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        output?.didSelectItem(at: indexPath.row)
    }
    
    func setupUI() {
        title = "Дебаг меню"
        view.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.cell)
        setupCloseButton()
    }
    
    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    @objc private func didTapClose() {
        output?.dismiss()
    }
}
