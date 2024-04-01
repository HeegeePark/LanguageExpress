//
//  UICollectionView+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import UIKit
import SnapKit

extension UICollectionView {
    // 컬렌션뷰 레이아웃 설정
    func setLayout(inset: UIEdgeInsets, spacing: CGFloat, insetFromSuperView: CGFloat = 0, ratio: CGFloat, colCount: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = (deviceWidth - ((colCount - 1) * spacing + inset.left + inset.right + 2 * insetFromSuperView)) / colCount
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * ratio)
        layout.sectionInset = inset
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionViewLayout = layout
    }
    
    // emptyView 설정
    func setEmptyView(title: String, message: String, image: UIImage) {
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.width, height: self.bounds.height))
            return view
        }()
        
        let imageView = {
            let view = UIImageView()
            view.image = image
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        let titleLabel = {
            let view = UILabel()
            view.text = title
            view.textColor = .headerNavy
            view.font = .sfPro18Bold
            return view
        }()
        
        let messageLabel = {
            let view = UILabel()
            view.text = message
            view.textColor = .lightGray
            view.font = .sfPro15Regular
            view.numberOfLines = 0
            view.textAlignment = .center
            return view
        }()
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(emptyView.snp.centerY)
            make.centerX.equalTo(emptyView.snp.centerX)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(emptyView).offset(20)
            make.trailing.equalTo(emptyView).offset(-20)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
            make.size.equalTo(100)
        }
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    static func phraseLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let groupMargin: CGFloat = 8
            let itemMargin: CGFloat = 8
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(488))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(488))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = .init(top: groupMargin, leading: groupMargin, bottom: groupMargin, trailing: groupMargin)
            
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 20
            return layoutSection
        }
        
        return layout
    }
}
