//
//  OCRTip.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit

enum OCRTip: CaseIterable {
    case english
    case center
    case clear
    
    var title: String {
        switch self {
        case .english:
            return "1️⃣ 정확도가 높은 영어 문장"
        case .center:
            return "2️⃣ 가운데 정렬이 잘 된 사진"
        case .clear:
            return "3️⃣ 글자가 또렷한 사진"
        }
    }
    
    static let sectionTitle = "텍스트 인식률을 높이는 \n사진 업로드 TIP"
    static let sectionSubtitle = "✅ 이런 사진이 좋아요!"
    static let exampleImage = UIImage()
}
