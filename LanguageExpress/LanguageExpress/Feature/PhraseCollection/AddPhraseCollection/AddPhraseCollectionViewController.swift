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
}
