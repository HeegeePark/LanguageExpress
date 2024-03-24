//
//  AddPhraseCollectionViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

final class AddPhraseCollectionViewController: BaseViewController {
    
    private let mainView = AddPhraseCollectionView()
    
    private let viewModel = AddPhraseCollectionViewModel()
    private var input: AddPhraseCollectionViewModel.Input!
    private var output: AddPhraseCollectionViewModel.Output!
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        mainView.delegate = self
    }
    
    func bindViewModel() {
        input = AddPhraseCollectionViewModel.Input(
            collectionNameChangedEvent: Observable(""),
            collectionColorChangedEvent: Observable(mainView.currentColor()),
            addButtonTappedEvent: Observable(nil)
        )
        
        output = viewModel.transform(from: input)
        
        output.failureToAddCollectionTrigger.bind { message in
            guard !message.isEmpty else { return }
            self.showToast(message)
        }
        
        output.successToAddCollectionTrigger.bind { event in
            guard event != nil else { return }
            self.dismiss(animated: true)
        }
    }
    
    override func configureNavigationBar(_ style: NavigationBarStyle = .default) {
        super.configureNavigationBar()
        
        navigationItem.title = "새 모음집"
        
        let dismiss = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        
        let add = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        
        navigationItem.leftBarButtonItem = dismiss
        navigationItem.rightBarButtonItem = add
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        input.addButtonTappedEvent.value = ()
    }
}

extension AddPhraseCollectionViewController: AddPhraseCollectionViewDelegate {
    func nameChanged(name: String) {
        input.collectionNameChangedEvent.value = name
    }
    
    func colorChanged(color: String) {
        input.collectionColorChangedEvent.value = color
    }
}
