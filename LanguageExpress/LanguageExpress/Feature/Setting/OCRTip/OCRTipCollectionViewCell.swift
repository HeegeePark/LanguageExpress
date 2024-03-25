//
//  OCRTipCollectionViewCell.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit
import SnapKit

final class OCRTipCollectionViewCell: UICollectionViewCell {
    private let titleLabel = {
        let lb = UILabel()
        lb.font = .sfPro15Regular
        lb.textColor = .black
        lb.numberOfLines = 2
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindData(title: String) {
        titleLabel.text = title
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        contentView.backgroundColor = .clear
    }
}
