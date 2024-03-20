//
//  CustomTextAreaView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit
import SnapKit

final class CustomTextAreaView: BaseView {
    private let titleLabel = {
        let lb = UILabel()
        lb.font = .sfPro17Bold
        lb.textColor = .black
        return lb
    }()
    
    private let optionalLabel = {
        let lb = UILabel()
        lb.text = "선택"
        lb.font = .sfPro12Bold
        lb.textColor = .strokeGray
        return lb
    }()
    
    private let textField = {
        let tf = UITextField()
        tf.font = .sfPro15Regular
        tf.setCornerRadius(.small)
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.strokeGray.cgColor
        return tf
    }()
    
    var showOptionalLabel: Bool = false {
        didSet {
            optionalLabel.isHidden = !showOptionalLabel
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    override func configureHierarchy() {
        [titleLabel, optionalLabel, textField].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide)
        }
        
        optionalLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).priority(.low)
            make.bottom.equalTo(titleLabel)
        }
        
        textField.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}
