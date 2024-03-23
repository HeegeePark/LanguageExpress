//
//  AlertBuilder.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import UIKit

final class AlertBuilder {
    private let baseViewController: UIViewController
    private let alertViewController = CustomAlertViewController()
    
    private var alertTitle: String?
    private var message: String?
    private var showCancel: Bool = true
    private var addActionConfirm: AddAction?
    
    init(viewController: UIViewController) {
        baseViewController = viewController
    }
    
    func setMessage(_ text: String) -> AlertBuilder {
        message = text
        return self
    }
    
    func addActionCancel(_ showCancel: Bool) -> AlertBuilder {
        self.showCancel = showCancel
        return self
    }
    
    func addActionConfirm(_ text: String, action: (() -> Void)? = nil) -> AlertBuilder {
        addActionConfirm = AddAction(text: text, action: action)
        return self
    }
    
    @discardableResult
    func show() -> Self {
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        alertViewController.message = message
        alertViewController.showCancel = showCancel
        alertViewController.addActionConfirm = addActionConfirm
        
        baseViewController.present(alertViewController, animated: true)
        return self
    }
}

struct AddAction {
    var text: String?
    var action: (() -> Void)?
}
