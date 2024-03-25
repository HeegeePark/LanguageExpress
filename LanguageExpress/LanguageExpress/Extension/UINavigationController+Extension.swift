//
//  UINavigationController+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/17/24.
//

import UIKit

extension UINavigationController {
    func configureNavigationBarAppearance(_ style: NavigationBarStyle = .default) {
        navigationBar.tintColor = style.tintColor
        navigationBar.standardAppearance = style.appearance
        navigationBar.compactAppearance = style.appearance
        navigationBar.scrollEdgeAppearance = style.appearance
        navigationBar.compactScrollEdgeAppearance = style.appearance
    }
}

enum NavigationBarStyle {
    case `default`
    case main
    case add
    
    var appearance: UINavigationBarAppearance {
        switch self {
        case .default:
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = titleTextAttributes
            appearance.shadowImage = UIImage()  // 선 제거
            return appearance
        case .main:
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .mainBackground
            appearance.titleTextAttributes = titleTextAttributes
            appearance.shadowImage = UIImage()  // 선 제거
            return appearance
        case .add:
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .primary
            appearance.titleTextAttributes = titleTextAttributes
            appearance.shadowImage = UIImage()  // 선 제거
            return appearance
        }
    }
    
    var titleTextAttributes: [NSAttributedString.Key : Any] {
        switch self {
        case .main:
            return [
                .foregroundColor: tintColor,
                .font: UIFont.sjHospital26Light
            ]
        default:
            return [
                .foregroundColor: tintColor
            ]
        }
        
    }
    
    var tintColor: UIColor {
        switch self {
        case .default:
            return .primary
        case.main:
            return .primary
        case .add:
            return .white
        }
    }
}
