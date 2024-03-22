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
    private var addActionConfirm: AddAction?
    
    init(viewController: UIViewController) {
        baseViewController = viewController
    }
    
    func setMessage(_ text: String) -> AlertBuilder {
        message = text
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
        
        alertViewController.alertTitle = alertTitle
        alertViewController.message = message
        alertViewController.addActionConfirm = addActionConfirm
        
        baseViewController.present(alertViewController, animated: true)
        return self
    }
}

struct AddAction {
    var text: String?
    var action: (() -> Void)?
}
