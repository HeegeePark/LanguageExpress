//
//  FloatyFactory.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import UIKit
import Floaty

final class PhraseFloatyFactory: FloatyCreator {
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
            item.title = "구문 추가하기"
            item.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            item.titleLabel.textAlignment = .right
            item.icon = UIImage(systemName: "pencil")
            item.handler = { item in
                completionHandelr(0)
                fab.close()
            }
            return item
        }()
        fab.addItem(item: addPhraseItem)
        
        let addPhraseByOCRItem = {
            let item = FloatyItem()
            item.buttonColor = .white
            item.tintColor = .primary
            item.title = "사진으로 구문 추가하기"
            item.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            item.titleLabel.textAlignment = .right
            item.icon = UIImage(systemName: "text.viewfinder")
            item.handler = { item in
                completionHandelr(1)
                fab.close()
            }
            return item
        }()
        fab.addItem(item: addPhraseByOCRItem)

        return fab
    }
}
