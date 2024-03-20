//
//  AddPhraseCollectionView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

protocol AddPhraseCollectionViewDelegate: UIViewController {
    func nameChanged(name: String)
    func colorChanged(color: String)
}

final class AddPhraseCollectionView: BaseView {
    weak var delegate: AddPhraseCollectionViewDelegate?
    
    private lazy var nameAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "컬렉션 이름")
        view.showOptionalLabel = false
        view.textFieldValueChanged = { [weak self] text in
            self?.delegate?.nameChanged(name: text)
        }
        return view
    }()
    
    private lazy var colorCodeSelectView = {
        let view = ColorSelectView()
        view.colorChanged = { [weak self] color in
            self?.delegate?.colorChanged(color: color)
        }
        return view
    }()
    
    func currentColor() -> String {
        return colorCodeSelectView.currentColor
    }
    
    override func configureHierarchy() {
        [nameAreaView, colorCodeSelectView].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        nameAreaView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        colorCodeSelectView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nameAreaView)
            make.top.equalTo(nameAreaView.snp.bottom).offset(20)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
}
