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
    
    private let viewModel = AddPhraseViewModel()
    private var input: AddPhraseViewModel.Input!
    private var output: AddPhraseViewModel.Output!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel(collection: Collection) {
        input = AddPhraseViewModel.Input(
            bindViewModelEvent: Observable(collection),
            phraseChangedEvent: Observable(""),
            meaningChangedEvent: Observable(""),
            memoChangedEvent: Observable(""),
            tagsChangedEvent: Observable([]),
            addButtonTappedEvent: Observable(nil)
        )
        
        output = viewModel.transform(from: input)
        
        output.failureToAddPhraseTrigger.bind { message in
            guard !message.isEmpty else { return }
            self.showToast(message)
        }
        
        output.successToAddPhraseTrigger.bind { event in
            guard event != nil else { return }
            self.dismiss(animated: true)
        }
    }
    
    override func configureView() {
        mainView.delegate = self
    }
    
    override func configureNavigationBar(_ style: NavigationBarStyle = .default) {
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
        input.addButtonTappedEvent.value = ()
    }
}

extension AddPhraseViewController: AddPhraseViewDelegate {
    func phraseChanged(phrase: String) {
        input.phraseChangedEvent.value = phrase
    }
    
    func meaningChanged(meaning: String) {
        input.meaningChangedEvent.value = meaning
    }
    
    func memoChanged(memo: String) {
        input.memoChangedEvent.value = memo
    }
    
    func tagChanged(tags: [String]) {
        input.tagsChangedEvent.value = tags
    }
}
