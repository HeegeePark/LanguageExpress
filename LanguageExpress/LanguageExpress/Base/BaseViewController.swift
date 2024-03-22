//
//  BaseViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/15/24.
//

import UIKit
import Toast

class BaseViewController: UIViewController, ViewDrawable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        configureNavigationBar()
    }
    
    func configureHierarchy() {
    }
    
    func configureLayout() {
    }
    
    func configureView() {
    }
    
    func configureNavigationBar() {
        navigationController?.configureNavigationBarAppearance()
        navigationItem.backButtonTitle = ""
    }
    
    func showToast(_ message: String) {
        view.makeToast(message, duration: 2, position: .center)
    }
}
