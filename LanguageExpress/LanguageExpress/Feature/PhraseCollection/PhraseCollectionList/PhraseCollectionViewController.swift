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
            phraseCollectionViewCellDidSelectItemAtEvent: Observable(-1)
        )
        
        output = viewModel.transform(from: input)
        
        output.collections.bind { collections in
            // TODO: 기본 모음집 default로 구현
            guard !collections.isEmpty else {
                return
            }
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
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
//        navigationItem.title = "\n외국어 급행열차 뿌뿌 🚇"
        
        let addCollection = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCollectionTapped))
        
        navigationItem.rightBarButtonItem = addCollection
    }
    
    @objc private func addCollectionTapped() {
        let addCollectionVC = UINavigationController(rootViewController: AddPhraseCollectionViewController())
        addCollectionVC.modalPresentationStyle = .fullScreen
        self.present(addCollectionVC, animated: true)
    }
    
    override func configureView() {
        mainView.pcCollectionView.delegate = self
        mainView.pcCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PhraseCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.collections.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "phraseCollection", for: indexPath) as! PCCollectionViewCell
        
        let collection = output.collections.value[indexPath.item]
        cell.bindData(data: collection)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        input.phraseCollectionViewCellDidSelectItemAtEvent.value = indexPath.item
    }
}
