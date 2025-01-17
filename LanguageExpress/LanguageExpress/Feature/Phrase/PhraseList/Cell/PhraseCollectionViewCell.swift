//
//  PhraseCollectionViewCell.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import UIKit
import SnapKit

final class PhraseListCollectionViewCell: UICollectionViewCell {
    private lazy var stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = inset
        return view
    }()
    
    private let phraseLabel = {
        let lb = UILabel()
        lb.font = .sfPro18Bold
        lb.textColor = .black
        lb.numberOfLines = 0
        return lb
    }()
    
    private let meaningLabel = {
        let lb = UILabel()
        lb.font = .sfPro15Regular
        lb.textColor = .black
        lb.numberOfLines = 0
        return lb
    }()
    
    private let memoLabel = {
        let lb = UILabel()
        lb.font = .sfPro15Regular
        lb.textColor = .subtitle
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var stateOfMemorizationButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .sfPro12Bold
        btn.setTitleColor(.white, for: .normal)
        btn.layer.borderWidth = 2
        btn.addTarget(self, action: #selector(stateOfMemorizationButtonTapped), for: .touchUpInside)
        btn.setCornerRadius(.small)
        return btn
    }()
    
    private lazy var bookMarkButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "bookmark"),
                     for: .normal)
        btn.tintColor = .accent
        btn.addTarget(self, action: #selector(bookMarkButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var ttsButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "speaker.wave.2.fill"),
                     for: .normal)
        btn.tintColor = .primary
        btn.addTarget(self, action: #selector(ttsButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    var bookMarkButtonTapHandler: (() -> Void)?
    var stateOfMemorizationButtonTapHandler: (() -> Void)?
    
    @objc private func bookMarkButtonTapped() {
        bookMarkButtonTapHandler?()
    }
    
    @objc private func stateOfMemorizationButtonTapped() {
        stateOfMemorizationButtonTapHandler?()
    }
    
    @objc private func ttsButtonTapped() {
        TTSManager.shared.play(phraseLabel.text!)
    }
    
    private let inset: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memoLabel.text = ""
    }
    
    func bindData(phrase: Phrase) {
        phraseLabel.text = phrase.phrase
        meaningLabel.text = phrase.meaning
        
        if let memo = phrase.memo {
            memoLabel.isHidden = false
            memoLabel.text = memo
        } else {
            memoLabel.isHidden = true
        }
        
        updateStateOfMemorizationButton(state: StateOfMemorization(rawValue: phrase.stateOfMemorizationRawValue)!)
        
        [phraseLabel, meaningLabel, memoLabel, stateOfMemorizationButton.titleLabel!].forEach {
            updateLabelLayout(label: $0)
        }
        
        let bookmarkImage = phrase.isBookMark ? "bookmark.fill": "bookmark"
        bookMarkButton.setImage(UIImage(systemName: bookmarkImage), for: .normal)
    }
    
    private func updateStateOfMemorizationButton(state: StateOfMemorization) {
        stateOfMemorizationButton.backgroundColor = state.color.withAlphaComponent(0.5)
        stateOfMemorizationButton.layer.borderColor = state.color.cgColor
        stateOfMemorizationButton.setTitle(state.title, for: .normal)
    }
    
    private func updateLabelLayout(label: UILabel) {
        let size = label.sizeThatFits(contentView.frame.size)
        label.frame.size = size
        
        switch label {
        case phraseLabel:
            phraseLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(size.height)
            }
        case meaningLabel:
            meaningLabel.snp.remakeConstraints { make in
                make.height.equalTo(size.height)
            }
        case memoLabel:
            memoLabel.snp.remakeConstraints { make in
                make.height.equalTo(size.height)
            }
        default:    // stateOfMemorizationButton.titleLabel!
            stateOfMemorizationButton.snp.remakeConstraints { make in
                make.centerY.equalTo(bookMarkButton)
                make.trailing.equalTo(bookMarkButton.snp.leading).offset(-8)
                make.height.equalTo(20)
                make.width.equalTo(size.width + inset * 2)
            }
        }
    }
    
    private func configure() {
        [stackView, stateOfMemorizationButton, bookMarkButton, ttsButton].forEach {
            contentView.addSubview($0)
        }
        [phraseLabel, meaningLabel, memoLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset).priority(.low)
            make.trailing.equalTo(stateOfMemorizationButton.snp.leading).offset(-1 * inset)
        }
        
        phraseLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        meaningLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(phraseLabel)
            make.top.equalTo(phraseLabel.snp.bottom).offset(inset)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(phraseLabel)
            make.top.equalTo(meaningLabel.snp.bottom).offset(inset)
            make.bottom.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(inset)
        }
        
        stateOfMemorizationButton.snp.makeConstraints { make in
            make.centerY.equalTo(bookMarkButton)
            make.trailing.equalTo(bookMarkButton.snp.leading).offset(-8)
            make.height.equalTo(20)
        }
        
        bookMarkButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(inset)
            make.size.equalTo(25)
        }
        
        ttsButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(inset)
            make.size.equalTo(25)
            make.top.greaterThanOrEqualTo(bookMarkButton.snp.bottom).offset(inset)
        }
        
        contentView.backgroundColor = .sheetBackground
        contentView.setCornerRadius()
    }
}
