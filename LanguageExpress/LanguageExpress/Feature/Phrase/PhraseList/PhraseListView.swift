//
//  PhraseListView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

final class PhraseListView: BaseView {
    // TODO: tag scrollview
    let phraseCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        // TODO: modern collectionView로 dynamic 대응
//        cv.setLayout(
//            inset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
//            spacing: 20,
//            ratio: 0.5,
//            colCount: 1
//        )
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(PhraseListCollectionViewCell.self, forCellWithReuseIdentifier: "phraseList")
        return cv
    }()
    
    static private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let groupMargin: CGFloat = 8
            let itemMargin: CGFloat = 8
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(140))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = .init(top: groupMargin, leading: groupMargin, bottom: groupMargin, trailing: groupMargin)
            
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 5
            return layoutSection
        }
        
        return layout
    }
    
    override func configureHierarchy() {
        self.addSubview(phraseCollectionView)
    }
    
    override func configureLayout() {
        phraseCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
}
