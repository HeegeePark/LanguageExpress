//
//  UINavigationItem+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

extension UINavigationItem {
    func setTitleView(title: String) {
        let titleViewLabel = TitleViewLabel()
        titleViewLabel.text = title
        self.leftBarButtonItem = UIBarButtonItem(customView: titleViewLabel)
    }
}
