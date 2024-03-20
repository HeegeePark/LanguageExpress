//
//  BaseView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import UIKit

class BaseView: UIView, ViewDrawable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
    }
    
    func configureLayout() {
    }
    
    func configureView() {
    }
}
