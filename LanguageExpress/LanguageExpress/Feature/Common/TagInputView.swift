//
//  TagInputView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import UIKit
import SnapKit

final class TagInputView: BaseView {
    private lazy var tagInputAreaView = {
        let view = CustomTextAreaView()
        view.setTitle(title: "태그")
        view.showOptionalLabel = true
        view.setTextFieldPlaceholder(text: "최대 3개 설정 가능")
        view.textFieldValueChanged = { [weak self] text in
            self?.currentTextFieldText = text
        }
        return view
    }()
    
    private lazy var addButton = {
        let view = UIButton()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.backgroundColor = .primary
        view.setCornerRadius()
        view.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private let tagStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.spacing = 8
        view.backgroundColor = .clear
        return view
    }()
    
    private var currentTextFieldText: String = ""
    
    private var selectedTags: Set<String> = Set() {
        didSet {
            selectedTagsUpdated?(Array(selectedTags))
        }
    }
    
    var selectedTagsUpdated: (([String]) -> Void)?
    
    @objc private func addButtonTapped() {
        guard !currentTextFieldText.whiteSpaceRemoved.isEmpty else {
            tagInputAreaView.resetTextField()
            return
        }
        
        guard selectedTags.count < 3 else {
            return
        }
        
        if !selectedTags.contains(currentTextFieldText) {
            selectedTags.insert(currentTextFieldText)
            addTagView(title: currentTextFieldText)
            tagInputAreaView.resetTextField()
        }
    }
    
    private func addTagView(title: String) {
        let tagView = TagView()
        tagView.setTitle(title)
        let width = tagView.titleViewWidth()
        tagStackView.addArrangedSubview(tagView)
        tagView.snp.makeConstraints {
            let inset: CGFloat = 8
            $0.width.equalTo(inset * 2 + width)
        }
        
        tagView.removeButtonTappedHandler = {
            self.tagStackView.removeArrangedSubview(tagView)
            tagView.removeFromSuperview()
            self.selectedTags.remove(title)
        }
    }
    
    override func configureHierarchy() {
        [tagInputAreaView, addButton, tagStackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        tagInputAreaView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(tagInputAreaView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(tagInputAreaView)
            make.size.equalTo(40)
        }
        
        tagStackView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(8)
            make.bottom.leading.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
    }
}
