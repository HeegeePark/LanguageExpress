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
    private var input: PhraseCollectionViewModel.Input!
    private var output: PhraseCollectionViewModel.Output!
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        input.viewDidAppearEvent.value = ()
    }
    
    func bindViewModel() {
        input = PhraseCollectionViewModel.Input(
            viewDidAppearEvent: Observable(nil),
            phraseCollectionViewCellDidSelectItemAtEvent: Observable(-1),
            deleteCollectionAlertConfirmEvent: Observable(-1),
            addFloatingButtonTappedEvent: Observable(nil)
        )
        
        output = viewModel.transform(from: input)
        
        output.collections.bind { collections in
            // TODO: 기본 모음집 default로 구현
            self.mainView.pcCollectionView.reloadData()
        }
        
        output.collectionToPush.bind { collection in
            guard let collection else {
                return
            }
            
            let vc = PhraseListViewController()
            vc.bindViewModel(collection: collection)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        output.addCollectionToPush.bind { event in
            guard event != nil else { return }
            let addCollectionVC = UINavigationController(rootViewController: AddPhraseCollectionViewController())
            addCollectionVC.modalPresentationStyle = .fullScreen
            self.present(addCollectionVC, animated: true)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        //        navigationItem.title = "\n외국어 급행열차 뿌뿌 🚇"
        
        let tipButton = TipBarButtonItem(baseViewController: self)
        navigationItem.rightBarButtonItem = tipButton
    }
    
    override func configureView() {
        mainView.pcCollectionView.delegate = self
        mainView.pcCollectionView.dataSource = self
        mainView.setFloaty(vc: self) { [weak self] sender in
            self?.input.addFloatingButtonTappedEvent.value = ()
        }
        registerLongPressGesture()
    }
    
    private func registerLongPressGesture() {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(collectionViewlongPressed))
        gesture.cancelsTouchesInView = false
        mainView.pcCollectionView.addGestureRecognizer(gesture)
    }
    
    @objc private func collectionViewlongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: mainView.pcCollectionView)
            if let indexPath = mainView.pcCollectionView.indexPathForItem(at: touchPoint) {
                showDeletePhraseAlert(at: indexPath.item)
            }
        }
    }
    
    private func showDeletePhraseAlert(at idx: Int) {
        AlertBuilder(viewController: self)
            .setMessage(Message.deleteCollectionAlert)
            .addActionConfirm("삭제") {
                self.input.deleteCollectionAlertConfirmEvent.value = idx
            }
            .show()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PhraseCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if output.collections.value.isEmpty {
            collectionView.setEmptyView(
                title: "모음집이 없어요!",
                message: "우측하단의 추가 버튼을 눌러 모음집을 만들어봐요 :)",
                image: .collectionEmpty
            )
        } else {
            collectionView.restore()
        }
        
        return output.collections.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "phraseCollection", for: indexPath) as! PCCollectionViewCell
        
        let collection = output.collections.value[indexPath.item]
        cell.bindData(data: collection)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "customHeader",
                for: indexPath
              ) as? PCCollectionHeaderView else {return UICollectionReusableView()}
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        input.phraseCollectionViewCellDidSelectItemAtEvent.value = indexPath.item
    }
}
