//
//  LoaderView.swift
//  Fluffbotics
//
//  Created by Equipp on 27/11/25.
//

import Foundation
import UIKit

class LoaderView {
    static var spinnerBg: UIView?

    static func show(on view: UIView) {
        DispatchQueue.main.async {
            // Avoid showing twice
            if spinnerBg != nil { return }

            // Background (white square)
            let bg = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
            bg.backgroundColor = .white
            bg.layer.cornerRadius = 14
            bg.center = view.center
            bg.layer.shadowColor = UIColor.black.cgColor
            bg.layer.shadowOpacity = 0.15
            bg.layer.shadowOffset = CGSize(width: 0, height: 3)
            bg.layer.shadowRadius = 8

            // Spinner
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = UIColor(hex: "#675FAA")     // Your purple color
            spinner.center = CGPoint(x: bg.bounds.midX, y: bg.bounds.midY)
            spinner.startAnimating()

            bg.addSubview(spinner)
            view.addSubview(bg)

            spinnerBg = bg
        }
    }

    static func hide() {
        DispatchQueue.main.async {
            spinnerBg?.removeFromSuperview()
            spinnerBg = nil
        }
    }
}

// MARK: - HEX Color Extension
extension UIColor {
    convenience init(hex: String) {
        var clean = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        clean = clean.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
