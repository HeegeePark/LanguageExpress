//
//  FloatyFactory.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import UIKit
import Floaty

protocol FloatyCreator {
    static func makeFloaty(vc: UIViewController & FloatyDelegate, _ completionHandelr: @escaping (UIViewController) -> Void) -> Floaty
}

// 여러 화면에서 커스텀 플로팅 버튼을 쓸 것을 감안한 factory
final class FloatyFactory: FloatyCreator {
    static func makeFloaty(vc: UIViewController & FloatyDelegate, _ completionHandelr: @escaping (UIViewController) -> Void) -> Floaty {
        let fab = Floaty()
        fab.buttonColor = .primary
        fab.plusColor = .white
        fab.openAnimationType = .slideUp
        fab.fabDelegate = vc
        
        let addPhraseItem = {
            let item = FloatyItem()
            item.buttonColor = .white
            item.tintColor = .primary
            item.title = "구문 추가하기"
            item.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            item.titleLabel.textAlignment = .right
            item.icon = UIImage(systemName: "pencil")
            item.handler = { item in
                let addVC = UINavigationController(rootViewController: AddPhraseViewController())
                addVC.modalPresentationStyle = .fullScreen
                completionHandelr(addVC)
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
                // TODO: phpicker 연결
            }
            return item
        }()
        fab.addItem(item: addPhraseByOCRItem)
        
        let closeItem = {
            let item = FloatyItem()
            item.buttonColor = .accent
            item.tintColor = .primary
            item.icon = UIImage(systemName: "xmark")
            item.buttonColor = .accent
            item.titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            item.titleLabel.textAlignment = .right
            return item
        }()
        fab.addItem(item: closeItem)

        return fab
    }
}
