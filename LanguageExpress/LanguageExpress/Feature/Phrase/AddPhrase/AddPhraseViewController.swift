//
//  AddPhraseViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import UIKit

final class AddPhraseViewController: BaseViewController {
    
    private let mainView = AddPhraseView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.title = "새 구문"
        
        let dismiss = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        
        let add = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(addButtonTapped))
        
        navigationItem.leftBarButtonItem = dismiss
        navigationItem.rightBarButtonItem = add
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
    }
}
