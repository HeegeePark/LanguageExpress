//
//  AddPhraseCollectionView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import UIKit

final class AddPhraseCollectionView: BaseView {
    private let nameAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "컬렉션 이름")
        view.showOptionalLabel = false
        return view
    }()
    
    private let colorCodeSelectView = {
        let view = ColorSelectView()
        return view
    }()
    
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
