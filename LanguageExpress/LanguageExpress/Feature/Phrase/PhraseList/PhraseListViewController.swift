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
            phraseCollectionViewCellBookMarkButtonTappedEvent: Observable(-1),
            phraseCollectionViewCellStateOfMemorizationButtonTappedEvent: Observable(-1),
            addFloatingButtonTappedEvent: Observable(nil),
            deletePhraseAlertConfirmEvent: Observable(-1)
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
        }
    }
    
    override func configureView() {
        mainView.phraseCollectionView.dataSource = self
        mainView.phraseCollectionView.delegate = self
        registerLongPressGesture()
        mainView.setFloaty(vc: self) { [weak self] sender in
            self?.input.addFloatingButtonTappedEvent.value = ()
        }
    }
    
    private func registerLongPressGesture() {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(collectionViewlongPressed))
        mainView.phraseCollectionView.addGestureRecognizer(gesture)
    }
    
    @objc private func collectionViewlongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: mainView.phraseCollectionView)
            if let indexPath = mainView.phraseCollectionView.indexPathForItem(at: touchPoint) {
                showDeletePhraseAlert(at: indexPath.item)
            }
        }
    }
    
    private func showDeletePhraseAlert(at idx: Int) {
        AlertBuilder(viewController: self)
            .setMessage(Message.deletePhraseAlert)
            .addActionConfirm("삭제") {
                self.input.deletePhraseAlertConfirmEvent.value = idx
            }
            .show()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 뜻, 메모 on/off
//        input.phraseCollectionViewCellDidSelectItemAtEvent.value = indexPath.item
    }
}

extension PhraseListViewController: FloatyDelegate {
    func floatyWillOpen(_ floaty: Floaty) {
    }
    
    func floatyWillClose(_ floaty: Floaty) {
    }
}
