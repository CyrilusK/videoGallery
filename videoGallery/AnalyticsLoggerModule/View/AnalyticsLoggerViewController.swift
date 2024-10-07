//
//  AnalyticsLoggerViewController.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

final class AnalyticsLoggerViewController: UITableViewController, AnalyticsLoggerViewInputProtocol {
    var output: AnalyticsLoggerOutputProtocol?
    private var logs: [AnalyticsLog] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }

    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = K.logs
        tableView.register(AnalyticsLogCell.self, forCellReuseIdentifier: K.networkLogCell)
    }
    
    func setLogs(_ logs: [AnalyticsLog]) {
        self.logs = logs.reversed()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.networkLogCell, for: indexPath) as! AnalyticsLogCell
        let log = logs[indexPath.row]
        cell.configure(with: log)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
