//
//  PhraseCollectionView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import UIKit
import SnapKit

final class PhraseCollectionView: BaseView {
    lazy var pcCollectionView = {
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
        cv.register(PCCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "customHeader")
        return cv
    }()
    
    override func configureHierarchy() {
        self.addSubview(pcCollectionView)
    }
    
    override func configureLayout() {
        pcCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .mainBackground
    }
}
