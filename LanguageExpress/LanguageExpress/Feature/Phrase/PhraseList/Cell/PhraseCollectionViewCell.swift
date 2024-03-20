//
//  PhraseCollectionViewCell.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import UIKit
import SnapKit

final class PhraseListCollectionViewCell: UICollectionViewCell {
    private let phraseLabel = {
        let lb = UILabel()
        lb.text = "영어 구문 영어 구문영어 구문 영어 구문 영어 구문 영어 구문"
        lb.font = .sfPro18Bold
        lb.textColor = .black
        lb.numberOfLines = 0
        return lb
    }()
    
    private let meaningLabel = {
        let lb = UILabel()
        lb.text = "뜻 영어 구문영어 구문영어 구문영어 구문영어 구문영어 구문 fsdsf sdfs"
        lb.font = .sfPro15Regular
        lb.textColor = .black
        lb.numberOfLines = 0
        return lb
    }()
    
    private let memoLabel = {
        let lb = UILabel()
        lb.text = "메모"
        lb.font = .sfPro15Regular
        lb.textColor = .subtitle
        lb.numberOfLines = 0
        return lb
    }()
    
    // TODO: 암기 여부
//    private lazy var stateOfMemorizationButton = {
//        let btn = UIButton()
//        let state = StateOfMemorization.hard
//        btn.setTitle(state.title, for: .normal)
//        btn.titleLabel?.font = .sfPro12Bold
//        btn.setTitleColor(.white, for: .normal)
//        btn.backgroundColor = state.color.withAlphaComponent(0.5)
//        btn.layer.borderColor = state.color.cgColor
//        btn.layer.borderWidth = 2
//        // TODO: 클릭 이벤트(암기정도 변경)
//        btn.setCornerRadius(.small)
//        return btn
//    }()
    
    private lazy var bookmarkButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "bookmark"),
                     for: .normal)
        btn.tintColor = .accent
        // TODO: 북마크 클로저
        return btn
    }()
    
    private lazy var ttsButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "speaker.wave.2.fill"),
                     for: .normal)
        btn.tintColor = .primary
        // TODO: 발음듣기 클로저
        return btn
    }()
    
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
        
        [phraseLabel, meaningLabel, memoLabel].forEach {
            updateLabelLayout(label: $0)
        }
        
        let bookmarkImage = phrase.isBookMark ? "bookmark.fill": "bookmark"
        bookmarkButton.setImage(UIImage(systemName: bookmarkImage), for: .normal)
    }
    
    private func updateLabelLayout(label: UILabel) {
        let size = label.sizeThatFits(contentView.frame.size)
        label.frame.size = size
        
        switch label {
        case phraseLabel:
            phraseLabel.snp.remakeConstraints { make in
                make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(inset)
                make.trailing.equalTo(bookmarkButton.snp.leading).offset(-1 * inset)
                make.height.equalTo(size.height)
            }
        case meaningLabel:
            meaningLabel.snp.remakeConstraints { make in
                make.horizontalEdges.equalTo(phraseLabel)
                make.top.equalTo(phraseLabel.snp.bottom).offset(inset)
                make.height.equalTo(size.height)
            }
        default:
            memoLabel.snp.remakeConstraints { make in
                make.horizontalEdges.equalTo(phraseLabel)
                make.top.equalTo(meaningLabel.snp.bottom).offset(inset)
                make.bottom.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(inset)
                make.height.equalTo(size.height)
            }
        }
    }
    
    private func configure() {
        [phraseLabel, meaningLabel, memoLabel, bookmarkButton, ttsButton].forEach {
            contentView.addSubview($0)
        }
        
        phraseLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(inset)
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(-1 * inset)
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
        
//        stateOfMemorizationButton.snp.makeConstraints { make in
//            make.centerY.equalTo(phraseLabel)
//            make.leading.equalTo(phraseLabel.snp.trailing).offset(8)
//            make.height.equalTo(20)
//        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(inset)
            make.size.equalTo(25)
        }
        
        ttsButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(inset)
            make.size.equalTo(25)
        }
        
        contentView.backgroundColor = .sheetBackground
        contentView.setCornerRadius()
    }
}
