//
//  NetworkLogCell.swift
//  videoGallery
//
//  Created by Cyril Kardash on 03.10.2024.
//

import UIKit

final class NetworkLogCell: UITableViewCell {

    private let timestampLabel = UILabel()
    private let urlLabel = UILabel()
    private let methodStatusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [timestampLabel, urlLabel, methodStatusLabel])
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

    func configure(with log: NetworkLog) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss, dd/MM/yyyy"
        
        timestampLabel.text = dateFormatter.string(from: log.timestamp)
        urlLabel.text = log.url
        methodStatusLabel.text = log.method + " \(log.statusCode)"
        methodStatusLabel.textColor = log.statusCode == 200 ? .systemGreen : .red
    }
}

