//
//  PhraseListView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit
import Floaty

final class PhraseListView: BaseView {
    // TODO: tag scrollview
    let phraseCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(PhraseListCollectionViewCell.self, forCellWithReuseIdentifier: "phraseList")
        return cv
    }()
    
    private lazy var floatingButton = Floaty()
    
    func setFloaty(vc: UIViewController & FloatyDelegate,
                   handlerToPresent: @escaping (UIViewController) -> Void) {
        print(#function)
        floatingButton = FloatyFactory.makeFloaty(vc: vc) { vcToPresent in
            handlerToPresent(vcToPresent)
        }
        self.addSubview(floatingButton)
    }
    
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
