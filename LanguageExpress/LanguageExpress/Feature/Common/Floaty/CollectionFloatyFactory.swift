//
//  CollectionFloatyFactory.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/23/24.
//

import UIKit
import Floaty

final class CollectionFloatyFactory: FloatyCreator {
    static func makeFloaty(vc: UIViewController, _ completionHandelr: @escaping (Int) -> Void) -> Floaty {
        let fab = Floaty()
        fab.buttonColor = .primary
        fab.plusColor = .white
        fab.openAnimationType = .slideUp
        fab.paddingX = 30.adjusted
        fab.paddingY = 120.adjustedH
        
        let addPhraseItem = {
            let item = FloatyItem()
            item.buttonColor = .white
            item.tintColor = .primary
            item.title = "모음집 추가하기"
            item.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            item.titleLabel.textAlignment = .right
            item.icon = UIImage(systemName: "books.vertical")
            item.handler = { item in
                completionHandelr(0)
                fab.close()
            }
            return item
        }()
        fab.addItem(item: addPhraseItem)

        return fab
    }
}

