//
//  PhraseCollectionView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import UIKit
import SnapKit

class PhraseCollectionView: BaseView {
    private let titleLabel = {
        let lb = UILabel()
        lb.text = "문장 모음집"
        lb.font = .sfPro22Bold
        lb.textColor = .headerNavy
        return lb
    }()
    
    let pcCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        cv.setLayout(
            inset: UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36),
            spacing: 20,
            ratio: 122 / 170,
            colCount: 2
        )
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(PCCollectionViewCell.self, forCellWithReuseIdentifier: "phraseCollection")
        return cv
    }()
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(pcCollectionView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        
        pcCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .mainBackground
    }
}
