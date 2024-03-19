//
//  PhraseCollectionViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import UIKit

final class PhraseCollectionViewController: BaseViewController {
    
    private let mainView = PhraseCollectionView()
    
    private let viewModel = PhraseCollectionViewModel()
    var input: PhraseCollectionViewModel.Input!
    var output: PhraseCollectionViewModel.Output!
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        input = PhraseCollectionViewModel.Input(
            viewDidAppearEvent: Observable(nil),
            phraseCollectionViewCellDidSelectItemAtEvent: Observable(-1)
        )
        
        output = viewModel.transform(from: input)
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.title = "\n외국어 급행열차 뿌뿌 🚇"
    }
    
    override func configureView() {
        mainView.pcCollectionView.delegate = self
        mainView.pcCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PhraseCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "phraseCollection", for: indexPath) as! PCCollectionViewCell
        return cell
    }
}
