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
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionView.phraseLayout())
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(PhraseListCollectionViewCell.self, forCellWithReuseIdentifier: "phraseList")
        return cv
    }()
    
    private lazy var floatingButton = Floaty()
    
    func setFloaty(vc: UIViewController,
                   handlerToPresent: @escaping (Int) -> Void) {
        floatingButton = PhraseFloatyFactory.makeFloaty(vc: vc) { sender in
            handlerToPresent(sender)
        }
        self.addSubview(floatingButton)
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
