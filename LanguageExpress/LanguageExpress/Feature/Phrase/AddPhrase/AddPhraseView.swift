//
//  AddPhraseView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import UIKit

protocol AddPhraseViewDelegate: UIViewController {
    func phraseChanged(phrase: String)
    func meaningChanged(meaning: String)
    func memoChanged(memo: String)
    func tagChanged(tags: [String])
}

final class AddPhraseView: BaseView {
    weak var delegate: AddPhraseViewDelegate?
    
    private lazy var phraseAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "표현/구문/문장")
        view.showOptionalLabel = false
        view.textFieldValueChanged = { [weak self] text in
            self?.delegate?.phraseChanged(phrase: text)
        }
        return view
    }()
    
    private lazy var meaningAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "뜻")
        view.showOptionalLabel = false
        view.textFieldValueChanged = { [weak self] text in
            self?.delegate?.meaningChanged(meaning: text)
        }
        return view
    }()
    
    private lazy var memoAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "메모")
        view.showOptionalLabel = true
        view.textFieldValueChanged = { [weak self] text in
            self?.delegate?.memoChanged(memo: text)
        }
        return view
    }()
    
    private lazy var tagInputView = {
        let view = TagInputView()
        view.selectedTagsUpdated = { [weak self] tags in
            self?.delegate?.tagChanged(tags: tags)
        }
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
