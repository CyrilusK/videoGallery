//
//  NetworkRequestsViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

final class NetworkRequestsViewController: UITableViewController, NetworkRequestsViewInputProtocol {
    var output: NetworkRequestsOutputProtocol?
    private var logs: [NetworkLog] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }

    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = K.networkRequests
        tableView.register(NetworkLogCell.self, forCellReuseIdentifier: K.networkLogCell)
    }
    
    func setLogs(_ logs: [NetworkLog]) {
        self.logs = logs
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.networkLogCell, for: indexPath) as! NetworkLogCell
        let log = logs[indexPath.row]
        cell.configure(with: log)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output?.copyToClipboard(text: logs[indexPath.row].url)
    }
}

