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
    
    func setShadow(color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func setBorder(color: UIColor, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func removeShadow() {
        self.layer.shadowOpacity = 0
    }
    
    func showIndicator() {
        let indicator = UIActivityIndicatorView()
        let height = self.bounds.size.height
        let width = self.bounds.size.width
        indicator.center = CGPoint(x: width / 2, y: height / 2)
        indicator.style = .large
        indicator.tintColor = .white
        self.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func dismissIndicator() {
        for view in self.subviews {
            if let indicator = view as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
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
