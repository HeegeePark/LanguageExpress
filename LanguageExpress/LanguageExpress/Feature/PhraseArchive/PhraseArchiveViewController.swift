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
            phraseCollectionViewCellBookMarkButtonTappedEvent: Observable(-1),
            phraseCollectionViewCellStateOfMemorizationButtonTappedEvent: Observable(-1),
            selectedTitleAppendedEvent: Observable(-1),
            selectedTitleRemovedEvent: Observable(-1)
        )
        
        output = viewModel.transform(from: input)
        
        output.pagerTabTitleList.bind { [weak self] titles in
            guard let self else { return }
            
            guard !titles.isEmpty else {
                return
            }
            
            if output.didUpdateTitleAtOnce.value {
                self.mainView.removeTabButtons()
            }
            
            self.mainView.setup(titles: titles)
        }
        
        output.phraseList.bind { phrases in
            self.mainView.reloadCollectionView()
        }
    }
    
    override func configureView() {
        mainView.delegate = self
        mainView.setCollectionViewDelegate(target: self)
    }
    
    override func configureNavigationBar(_ style: NavigationBarStyle = .default) {
        super.configureNavigationBar()
        navigationItem.setTitleView(title: "모든 구문 모아보기")
    }
}

extension PhraseArchiveViewController: PhraseArchiveViewDelegate {
    func seledcted(at idx: Int) {
        input.selectedTitleAppendedEvent.value = idx
    }
    
    func deSeledcted(at idx: Int) {
        input.selectedTitleRemovedEvent.value = idx
    }
}

extension PhraseArchiveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: empty view
        return output.phraseList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "phraseList", for: indexPath) as! PhraseListCollectionViewCell
        
        cell.bookMarkButtonTapHandler = {
            self.input.phraseCollectionViewCellBookMarkButtonTappedEvent.value = indexPath.item
        }
        
        cell.stateOfMemorizationButtonTapHandler = {
            self.input.phraseCollectionViewCellStateOfMemorizationButtonTappedEvent.value = indexPath.item
        }
        
        let phrase = output.phraseList.value[indexPath.item]
        cell.bindData(phrase: phrase)
        
        return cell
    }
}
