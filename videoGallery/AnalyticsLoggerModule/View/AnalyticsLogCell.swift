//
//  AnalyticsLogCell.swift
//  videoGallery
//
//  Created by Cyril Kardash on 04.10.2024.
//

import UIKit

final class AnalyticsLogCell: UITableViewCell {

    private let timestampLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [timestampLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    func configure(with log: AnalyticsLog) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss, dd/MM/yyyy"
        
        timestampLabel.text = dateFormatter.string(from: log.timestamp)
        let parametersString = log.parameters.map { "\($0.key): \($0.value)" }.joined(separator: " ")
        descriptionLabel.text = "\(log.event): \(parametersString)"
    }
}
