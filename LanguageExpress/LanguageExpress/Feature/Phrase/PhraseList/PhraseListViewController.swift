//
//  PhraseListViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

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
            addFloatingButtonTappedEvent: Observable(-1),
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
        
        output.presentAddPhraseTrigger.bind { event in
            guard event != nil else { return }
            let addVC = AddPhraseViewController()
            addVC.bindViewModel(collection: collection)
            let nav = UINavigationController(rootViewController: addVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        
        output.presentAddPhraseWithOCRTrigger.bind { event in
            guard event != nil else { return }
            let ocrVC = OCRViewController()
            ocrVC.bindViewModel(collection: collection)
            let nav = UINavigationController(rootViewController: ocrVC)
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
            self?.input.addFloatingButtonTappedEvent.value = sender
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
    
    override func configureNavigationBar(_ style: NavigationBarStyle = .default) {
        super.configureNavigationBar()
    }
}

extension PhraseListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if output.phrases.value.isEmpty {
            collectionView.setEmptyView(
                title: "추가된 문장이 없어요",
                message: "문장을 추가하고 외국어 정복하러 가볼까요?",
                image: .phraseEmpty
            )
        } else {
            collectionView.restore()
        }
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
