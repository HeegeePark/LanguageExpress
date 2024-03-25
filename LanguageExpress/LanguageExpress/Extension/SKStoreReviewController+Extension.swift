//
//  SKStoreReviewController+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import Foundation
import StoreKit

extension SKStoreReviewController {
    static func requestReviewInScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene {
            self.requestReview(in: scene)
        }
    }
}
