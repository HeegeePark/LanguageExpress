//
//  UIView+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import UIKit

extension UIView {
    func setCornerRadius(_ style: CornerRoundStyle = .default) {
        self.layer.cornerRadius = style.cornerRadius
        self.layer.masksToBounds = true
    }
}

enum CornerRoundStyle {
    case `default`
    case small
    case medium
    case large
    case circle(UIView)
    case custom(CGFloat)
    
    var cornerRadius: CGFloat {
        switch self {
        case .default:
            return 10
        case .small:
            return 8
        case .medium:
            return 16
        case .large:
            return 20
        case .circle(let view):
            return view.frame.width / 2
        case .custom(let point):
            return point
        }
    }
}
