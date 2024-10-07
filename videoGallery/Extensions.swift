//
//  Extensions.swift
//  videoGallery
//
//  Created by Cyril Kardash on 16.09.2024.
//

import UIKit

extension UIColor {
    static func fromNamedColor(_ name: String) -> UIColor? {
        switch name.lowercased() {
        case "black":
            return .black
        case "darkgray":
            return .darkGray
        case "lightgray":
            return .lightGray
        case "white":
            return .systemGroupedBackground
        case "gray":
            return .gray
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "cyan":
            return .cyan
        case "yellow":
            return .yellow
        case "magenta":
            return .magenta
        case "orange":
            return .orange
        case "purple":
            return .purple
        case "brown":
            return .brown
        case "clear":
            return .clear
        default:
            return nil
        }
    }
}
