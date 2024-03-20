//
//  AddPhraseCollectionViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

final class AddPhraseCollectionViewController: BaseViewController {
    
    private let mainView = AddPhraseCollectionView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        let dismiss = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        
        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        
        navigationItem.leftBarButtonItem = dismiss
        navigationItem.rightBarButtonItem = add
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        // TODO: realm에 추가
        print("add")
    }
}
