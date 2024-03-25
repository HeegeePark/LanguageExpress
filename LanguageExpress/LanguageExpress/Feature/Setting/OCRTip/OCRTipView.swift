//
//  OCRTipView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit
import SnapKit

final class OCRTipView: BaseView {
    private let exampleImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "example_fubao")!.withRenderingMode(.alwaysOriginal)
        view.contentMode = .scaleAspectFill
        view.setCornerRadius()
        return view
    }()
    
    private lazy var tipCollectionView = {
        let inset = 10.0
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 150
        layout.itemSize = CGSize(width: width, height: 40)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.isScrollEnabled = false
        view.register(OCRTipCollectionViewCell.self, forCellWithReuseIdentifier: "ocrTip")
        return view
    }()
    
    override func configureHierarchy() {
        self.addSubview(exampleImageView)
        self.addSubview(tipCollectionView)
    }
    
    override func configureLayout() {
        exampleImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.centerY.equalTo(tipCollectionView)
            make.height.equalTo(120)
            make.width.equalTo(100)
        }
        
        tipCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(exampleImageView.snp.trailing).offset(20)
            make.height.equalTo(140)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .clear
        tipCollectionView.backgroundColor = .clear
    }

}

extension OCRTipView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OCRTip.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ocrTip", for: indexPath) as! OCRTipCollectionViewCell
        cell.bindData(title: OCRTip.allCases[indexPath.item].title)
        return cell
    }
}

