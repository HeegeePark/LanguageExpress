//
//  StateOfMemorization.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import UIKit

enum StateOfMemorization: Int  {
    case hard
    case ambiguous
    case completed
    
    var title: String {
        switch self {
        case .hard:
            return "어려움"
        case .ambiguous:
            return "애매함"
        case .completed:
            return "마스터함"
        }
    }
    
    var color: UIColor {
        switch self {
        case .hard:
            return .accent
        case .ambiguous:
            return .subtitle
        case .completed:
            return .strokeGray
        }
    }
}
