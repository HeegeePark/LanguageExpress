//
//  UINavigationController+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/17/24.
//

import UIKit

extension UINavigationController {
    // TODO: 네비게이션 바 높이 늘리기
    func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        navigationBar.tintColor = .primary
    }
}
