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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.viewDidAppearEvent.value = ()
    }
    
    func bindViewModel(collection: Collection) {
        input = PhraseListViewModel.Input(
            bindViewModelEvent: Observable(collection), viewDidAppearEvent: Observable(nil),
            phraseCollectionViewCellDidSelectItemAtEvent: Observable(-1),
            phraseCollectionViewCellBookMarkButtonTappedEvent: Observable(-1), phraseCollectionViewCellStateOfMemorizationButtonTappedEvent: Observable(-1),
            addFloatingButtonTappedEvent: Observable(nil)
        )
        
        output = viewModel.transform(from: input)
        
        output.collection.bind { collection in
            guard let collection else { return }
            self.configureNavigationBar()
            self.navigationItem.title = collection.name
        }
        
        output.phrases.bind { phrases in
            self.mainView.phraseCollectionView.reloadData()
        }
        
        output.presentAddPhraseTrigger.bind { _ in
            let addVC = AddPhraseViewController()
            addVC.bindViewModel(collection: collection)
            let nav = UINavigationController(rootViewController: addVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        
        output.successToToggleIsBookMarkTrigger.bind { event in
            guard event != nil else { return }
            self.mainView.phraseCollectionView.reloadData()
        }
        
        output.successToChangeStateOfMemorizationTrigger.bind { event in
            guard event != nil else { return }
            self.mainView.phraseCollectionView.reloadData()
            print("success")
        }
    }
    
    override func configureView() {
        mainView.phraseCollectionView.dataSource = self
        mainView.phraseCollectionView.delegate = self
        mainView.setFloaty(vc: self) { [weak self] sender in
            self?.input.addFloatingButtonTappedEvent.value = ()
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
        
        cell.bookMarkButtonTapHandler = {
            self.input.phraseCollectionViewCellBookMarkButtonTappedEvent.value = indexPath.item
        }
        
        cell.stateOfMemorizationButtonTapHandler = {
            self.input.phraseCollectionViewCellStateOfMemorizationButtonTappedEvent.value = indexPath.item
        }
        
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
