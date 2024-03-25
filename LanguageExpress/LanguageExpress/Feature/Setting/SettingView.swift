//
//  SettingView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit
import SnapKit
import StoreKit

final class SettingView: BaseView {
    private let headerView = {
        let view = UIView()
        view.setCornerRadius(.medium)
        view.backgroundColor = .sheetBackground
        view.setShadow()
        return view
    }()
    
    private lazy var titleLabel = {
        let lb = UILabel()
        lb.text = OCRTip.sectionTitle
        lb.font = .sfPro22Bold
        lb.textColor = .primary
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
    
    private let rateView = {
        let view = RateView()
        view.setCornerRadius(.medium)
        view.backgroundColor = .sheetBackground
        view.setShadow()
        return view
    }()
    
    @objc private func rateViewTapped() {
        print("hi")
        SKStoreReviewController.requestReviewInScene()
    }
    
    override func configureHierarchy() {
        self.addSubview(headerView)
        [titleLabel, subtitleLabel, ocrTipView].forEach {
            headerView.addSubview($0)
        }
        self.addSubview(rateView)
    }
    
    override func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200).priority(.low)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        ocrTipView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(140)
            make.bottom.equalToSuperview().inset(20)
        }
        
        rateView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .mainBackground
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(rateViewTapped))
        rateView.addGestureRecognizer(gesture)
    }
}
