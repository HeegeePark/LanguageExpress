//
//  PhraseListViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit
import Floaty

final class PhraseListViewController: BaseViewController {
    private let mainView = PhraseListView()
    
    override func loadView() {
        view = mainView
    }
    
    private let viewModel = PhraseListViewModel()
    private var input: PhraseListViewModel.Input!
    private var output: PhraseListViewModel.Output!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel(collection: Collection) {
        input = PhraseListViewModel.Input(
            bindViewModelEvent: Observable(collection),
            phraseCollectionViewCellDidSelectItemAtEvent: Observable(-1)
        )
        
        output = viewModel.transform(from: input)
        
        output.collectionName.bind { name in
            guard !name.isEmpty else { return }
            self.configureNavigationBar()
            self.navigationItem.title = name
        }
        
        output.phrases.bind { phrases in
            self.mainView.phraseCollectionView.reloadData()
        }
    }
    
    override func configureView() {
        mainView.phraseCollectionView.dataSource = self
        mainView.phraseCollectionView.delegate = self
        mainView.setFloaty(vc: self) { [weak self] vcToPresent in
            self?.present(vcToPresent, animated: true)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
    }
}

extension PhraseListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.phrases.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "phraseList", for: indexPath) as! PhraseListCollectionViewCell
        
        let phrase = output.phrases.value[indexPath.item]
        cell.bindData(phrase: phrase)
        
        return cell
    }
}

extension PhraseListViewController: FloatyDelegate {
    func floatyWillOpen(_ floaty: Floaty) {
    }
    
    func floatyWillClose(_ floaty: Floaty) {
    }
}
