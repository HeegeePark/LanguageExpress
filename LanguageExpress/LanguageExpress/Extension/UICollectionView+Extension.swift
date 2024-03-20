//
//  UICollectionView+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import UIKit

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
}
