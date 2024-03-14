//
//  UIColor+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/15/24.
//

import UIKit

extension UIColor {
    static let primary = UIColor(hex: "#0F1035")
    static let accent = UIColor(hex: "#FBA834")
    static let mainBackground = UIColor(hex: "#E6EFFF")
    static let sheetBackground = UIColor(hex: "#F2F5FC")
    static let progressBarBackground = UIColor(hex: "#D9D9D9")
    static let deactiveGray = UIColor(hex: "#606060")
    static let strokeGray = UIColor(hex: "#8A8A8A")
    static let subtitle = UIColor(hex: "#454861")
    static let headerNavy = UIColor(hex: "#23233D")
}

extension UIColor {
    convenience init(hex: String) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}
