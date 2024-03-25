//
//  PCCollectionViewCell.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import UIKit

final class PCCollectionViewCell: UICollectionViewCell {
    private let nameLabel = {
        let lb = UILabel()
        lb.font = .sjHospital22Bold
        lb.textColor = .black
        return lb
    }()
    
    private let completionRateLabel = {
        let lb = UILabel()
        lb.font = .sfPro12Bold
        lb.textColor = .subtitle
        return lb
    }()
    
    lazy var completionRateProgressView = {
        let pv = UIProgressView()
        pv.trackTintColor = .progressBarBackground
        pv.progressTintColor = .accent
        pv.progress = 0.35
        return pv
    }()
    
    private let chevronButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.right.circle.fill"),
                     for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .black
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindData(data: Collection) {
        nameLabel.text = data.name
        let completionRate = RealmManager.shared.completionRate(collection: data)
        let completionRateToPercentage = String(Int(completionRate * 100))
        completionRateLabel.text = "\(completionRateToPercentage)% 마스터 완료!"
        completionRateProgressView.progress = completionRate
        completionRateProgressView.progressTintColor = UIColor(hex: data.color)
    }
    
    private func configure() {
        [nameLabel, completionRateLabel, completionRateProgressView, chevronButton].forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(8.adjustedH)
        }
        
        completionRateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8.adjustedH)
        }
        
        completionRateProgressView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nameLabel)
            make.top.equalTo(completionRateLabel.snp.bottom).offset(8.adjustedH)
            make.height.equalTo(6.adjustedH)
        }
        
        chevronButton.snp.makeConstraints { make in
            make.top.equalTo(completionRateProgressView.snp.bottom).offset(6.adjustedH)
            make.bottom.trailing.equalToSuperview().inset(8.adjustedH)
            make.leading.greaterThanOrEqualToSuperview().inset(8)
            make.width.equalTo(24)
            make.height.equalTo(24.adjustedH)
        }
        
        contentView.backgroundColor = .white
        contentView.setCornerRadius()
    }
}
