//
//  CGFloat+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit

// iPhone 15 Pro (393.0, 852.0)
extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 393
        return self * ratio
    }
    
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 852
        return self * ratio
    }
}

extension Double {
    var adjusted: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 393)
        return self * ratio
    }
    
    var adjustedH: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height / 852)
        return self * ratio
    }
}
