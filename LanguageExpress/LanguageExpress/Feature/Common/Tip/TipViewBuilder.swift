//
//  TipViewBuilder.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/23/24.
//

import UIKit

final class TipViewBuilder {
    private let baseViewController: UIViewController
    private let tipViewController = TipViewController()
    
    private var tipTitle: String?
    private var message: String?
    private var image: UIImage?
    
    init(viewController: UIViewController) {
        baseViewController = viewController
    }
    
    func setTitle(_ text: String) -> TipViewBuilder {
        tipTitle = text
        return self
    }
    
    func setMessage(_ text: String) -> TipViewBuilder {
        message = text
        return self
    }
    
    func setImage(_ image: UIImage) -> TipViewBuilder {
        self.image = image
        return self
    }
    
    @discardableResult
    func show() -> Self {
        tipViewController.modalPresentationStyle = .overFullScreen
        tipViewController.modalTransitionStyle = .crossDissolve
        
        tipViewController.tipTitle = tipTitle
        tipViewController.message = message
        tipViewController.image = image
        
        baseViewController.present(tipViewController, animated: true)
        return self
    }
}
