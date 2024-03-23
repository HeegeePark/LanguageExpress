//
//  UITextField+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding: CGFloat = 10) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
