//
//  SettingView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    private lazy var titleLabel = {
        let lb = UILabel()
        lb.text = OCRTip.sectionTitle
        lb.font = .sfPro22Bold
        lb.textColor = .black
        lb.numberOfLines = 2
        return lb
    }()
    
    private lazy var subtitleLabel = {
        let lb = UILabel()
        lb.text = OCRTip.sectionSubtitle
        lb.font = .sfPro17Bold
        lb.textColor = .black
        return lb
    }()
    
    private let ocrTipView = {
        let view = OCRTipView()
        return view
    }()
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(ocrTipView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        ocrTipView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(140)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .mainBackground
    }
}
