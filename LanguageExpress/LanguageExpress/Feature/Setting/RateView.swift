//
//  RateView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit
import SnapKit

final class RateView: BaseView {
    private lazy var imageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.image = .star
        return view
    }()
    
    private lazy var titleLabel = {
        let view = UILabel()
        view.font = .sfPro14Bold
        view.textColor = .label
        view.textAlignment = .center
        view.text = "앱이 마음에 드시나요? 리뷰를 남겨주세요"
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var messageLabel = {
        let view = UILabel()
        view.font = .sfPro13Regular
        view.textColor = .label
        view.textAlignment = .center
        view.text = "해당 영역을 터치하면 앱스토어 리뷰로 넘어갑니다."
        view.numberOfLines = 0
        return view
    }()
    
    override func configureHierarchy() {
        [imageView, titleLabel, messageLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(imageView)
            make.leading.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.width.equalTo(imageView)
            make.leading.equalTo(imageView)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }

}
