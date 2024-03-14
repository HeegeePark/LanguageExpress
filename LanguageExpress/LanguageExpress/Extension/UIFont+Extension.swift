//
//  UIFont+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/15/24.
//

import UIKit

extension UIFont {
    static let sjHospital26Light = sjHospital(size: 26, weight: .light)
    static let sfPro24Regular = UIFont.systemFont(ofSize: 24)
    static let sfPro22Bold = UIFont.systemFont(ofSize: 22, weight: .bold)
    static let sfPro18Bold = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let sfPro17Bold = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let sfPro15Regular = UIFont.systemFont(ofSize: 15)
    static let sfPro12Bold = UIFont.systemFont(ofSize: 12, weight: .bold)
}

extension UIFont {
    private static func sjHospital(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let prefix = "Sejong hospital"
        
        var weightStr: String {
            switch weight {
            case .bold:
                return "Bold"
            default:
                return "Light"
            }
        }
        
        return UIFont(name: prefix + " " + weightStr, size: size) ?? .systemFont(ofSize: size, weight: weight)
    }
}
