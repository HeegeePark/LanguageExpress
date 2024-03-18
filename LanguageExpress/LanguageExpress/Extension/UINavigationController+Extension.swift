//
//  UINavigationController+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/17/24.
//

import UIKit

extension UINavigationController {
    func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        
        appearance.largeTitleTextAttributes = [.font: UIFont.sjHospital26Light,
                                               .foregroundColor: UIColor.headerNavy]
        navigationBar.tintColor = .accent
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonTitle = ""
    }
}
