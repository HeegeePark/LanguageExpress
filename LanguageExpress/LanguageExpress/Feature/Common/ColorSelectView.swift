//
//  ColorSelectView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit
import SnapKit

final class ColorSelectView: BaseView {
    private let titleLabel = {
        let lb = UILabel()
        lb.text = "대표 컬러"
        lb.font = .sfPro17Bold
        lb.textColor = .black
        return lb
    }()
    
    private let reloadButton = {
        let btn = UIButton()
        btn.setCornerRadius()
        btn.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // TODO: 사용자 입력 컬러코드 텍스트필드
//    private let colorCodeTextField = {
//        let tf = UITextField()
//        tf.font = .sfPro15Regular
//        tf.setCornerRadius(.small)
//        tf.layer.borderWidth = 2
//        tf.layer.borderColor = UIColor.strokeGray.cgColor
//        return tf
//    }()
    
    private var randomCode: String {
        let digits = (0..<6).map { _ in
            String(format: "%X", arc4random_uniform(16))
        }.joined()
        
        return "#" + digits
    }
    
    @objc private func reloadButtonTapped() {
        updateRandom()
    }
    
    private func updateRandom() {
        let random = randomCode
        reloadButton.backgroundColor = UIColor(hex: random)
//        colorCodeTextField.text = random
    }
    
    override func configureHierarchy() {
        [titleLabel, reloadButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.size.equalTo(50)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
//        colorCodeTextField.snp.makeConstraints { make in
//            make.verticalEdges.equalTo(reloadButton)
//            make.leading.equalTo(reloadButton.snp.trailing).offset(10)
//            make.trailing.equalTo(self.safeAreaLayoutGuide)
//        }
    }
    
    override func configureView() {
        updateRandom()
    }
}

extension ColorSelectView: UITextFieldDelegate {
    
}
