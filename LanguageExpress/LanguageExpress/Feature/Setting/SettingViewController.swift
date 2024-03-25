//
//  SettingViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let mainView = SettingView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNavigationBar(_ style: NavigationBarStyle = .default) {
        super.configureNavigationBar(.main)
    }
}
