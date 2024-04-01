//
//  UINavigationItem+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

extension UINavigationItem {
    func setTitleView(title: String, style: TitleStyle = .large) {
        let titleViewLabel = TitleViewLabel()
        titleViewLabel.text = title
        titleViewLabel.font = style.font
        self.leftBarButtonItem = UIBarButtonItem(customView: titleViewLabel)
    }
}

extension UINavigationItem {
    enum TitleStyle {
        case small
        case large
        
        var font: UIFont {
            switch self {
            case .small:
                return .sjHospital16Bold
            case .large:
                return .sjHospital26Light
            }
        }
    }
}
