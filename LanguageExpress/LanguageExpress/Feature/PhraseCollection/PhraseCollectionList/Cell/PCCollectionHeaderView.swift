//
//  PCCollectionHeaderView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import UIKit
import SnapKit

class PCCollectionHeaderView: UICollectionReusableView {
    private lazy var titleLabel = {
        let lb = UILabel()
        lb.text = "문장 모음집"
        lb.font = .sfPro22Bold
        lb.textColor = .headerNavy
        return lb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
        configure()
    }
    
    func configure() {
        self.backgroundColor = .clear
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.verticalEdges.equalTo(20)
        }
    }
}
