//
//  PhraseArchiveViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/30/24.
//

import UIKit

final class PhraseArchiveViewController: BaseViewController {
    private let mainView = PhraseArchiveView()
    
    private let viewModel = PhraseArchiveViewModel()
    private var input: PhraseArchiveViewModel.Input!
    private var output: PhraseArchiveViewModel.Output!
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        input.viewDidLoadEvent.value = ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.viewDidAppearEvent.value = ()
    }
    
    private func bindViewModel() {
        input = PhraseArchiveViewModel.Input(
            viewDidLoadEvent: Observable(nil),
            viewDidAppearEvent: Observable(nil),
            selectedTitleAppendedEvent: Observable(-1),
            selectedTitleRemovedEvent: Observable(-1)
        )
        
        output = viewModel.transform(from: input)
        
        output.pagerTabTitleList.bind { [weak self] titles in
            guard let self else { return }
            
            guard !titles.isEmpty else {
                print("hi")
                return
            }
            
            if output.didUpdateTitleAtOnce.value {
                self.mainView.removeTabButtons()
            }
            
            self.mainView.setup(titles: titles)
        }
        
        output.phraseList.bind { phrases in
            print(phrases)
        }
    }
    
    override func configureNavigationBar(_ style: NavigationBarStyle = .default) {
        super.configureNavigationBar()
        navigationItem.setTitleView(title: "모든 구문 모아보기")
    }
}
