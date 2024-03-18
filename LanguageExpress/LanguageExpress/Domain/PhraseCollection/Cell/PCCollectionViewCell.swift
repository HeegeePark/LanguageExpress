//
//  PCCollectionViewCell.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import UIKit

class PCCollectionViewCell: UICollectionViewCell {
    private let nameLabel = {
        let lb = UILabel()
        lb.text = "컬렉션 이름"
        lb.font = .sfPro24Regular
        lb.textColor = .black
        return lb
    }()
    
    private let completionRateLabel = {
        let lb = UILabel()
        lb.text = "35% 마스터 완료!"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [nameLabel, completionRateLabel, completionRateProgressView].forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(8)
        }
        
        completionRateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        completionRateProgressView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(completionRateLabel.snp.bottom).offset(8)
            make.width.equalTo(120)
            make.height.equalTo(6)
        }
        
        contentView.backgroundColor = .white
        contentView.setCornerRadius()
    }
}
