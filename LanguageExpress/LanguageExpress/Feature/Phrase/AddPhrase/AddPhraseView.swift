//
//  AddPhraseView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import UIKit

protocol AddPhraseViewDelegate: UIViewController {
    func phraseChanged(name: String)
    func meaningChanged(meaning: String)
    func memoChanged(memo: String)
    func tagChanged(tags: [String])
    func collectionSelected(collection: Collection)
}

final class AddPhraseView: BaseView {
    weak var delegate: AddPhraseViewDelegate?
    
    private lazy var phraseAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "표현/구문/문장")
        view.showOptionalLabel = false
        view.textFieldValueChanged = { [weak self] text in
            self?.delegate?.phraseChanged(name: text)
        }
        return view
    }()
    
    private lazy var meaningAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "뜻")
        view.showOptionalLabel = false
        view.textFieldValueChanged = { [weak self] text in
            self?.delegate?.phraseChanged(name: text)
        }
        return view
    }()
    
    private lazy var memoAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "메모")
        view.showOptionalLabel = true
        view.textFieldValueChanged = { [weak self] text in
            self?.delegate?.phraseChanged(name: text)
        }
        return view
    }()
    
    private let tagInputView = {
        let view = TagInputView()
        return view
    }()
    
    override func configureHierarchy() {
        [phraseAreaView, meaningAreaView, memoAreaView, tagInputView].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        phraseAreaView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        meaningAreaView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(phraseAreaView)
            make.top.equalTo(phraseAreaView.snp.bottom).offset(20)
        }
        
        memoAreaView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(phraseAreaView)
            make.top.equalTo(meaningAreaView.snp.bottom).offset(20)
        }
        
        tagInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(phraseAreaView)
            make.top.equalTo(memoAreaView.snp.bottom).offset(20)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
}
