//
//  TitleViewLabel.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

class TitleViewLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.font = .sfPro18Bold
        self.textColor = .black
    }
}
