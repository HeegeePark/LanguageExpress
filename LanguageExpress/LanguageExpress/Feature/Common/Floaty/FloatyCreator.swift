//
//  FloatyCreator.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/23/24.
//

import UIKit
import Floaty

// 여러 화면에서 커스텀 플로팅 버튼을 쓸 것을 감안한 factory 패턴
@objc protocol FloatyCreator: AnyObject {
    @objc optional static func makeFloaty(vc: UIViewController, _ completionHandelr: @escaping (Int) -> Void) -> Floaty
    @objc optional static func makeFloatyWithDelegate(vc: UIViewController & FloatyDelegate, _ completionHandelr: @escaping (Int) -> Void) -> Floaty
}
