//
//  OCRTextAreaView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/24/24.
//

import UIKit

final class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var text: String?
}

protocol OCRTextAreaViewDelegate: UIView {
    func viewSelected(wordInfo: WordInfo, isSelect: Bool)
}

final class OCRTextAreaView: BaseView {
    weak var delegate: OCRTextAreaViewDelegate?
    private var tapGesture: CustomTapGestureRecognizer = CustomTapGestureRecognizer()
    private var isSelected: Bool = false {
        didSet {
            if isSelected {
                selectView()
            } else {
                deselectView()
            }
        }
    }
    
    func setResult(text: String, idx: Int) {
        self.tag = idx
        tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(textAreaTapped))
        tapGesture.text = text
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textAreaTapped(_ sender: CustomTapGestureRecognizer) {
        isSelected.toggle()
        delegate?.viewSelected(
            wordInfo: WordInfo(identifier: self.tag,
                               word: sender.text!),
            isSelect: isSelected
        )
    }
    
    override func configureView() {
        deselectView()
    }
    
    private func deselectView() {
        self.backgroundColor = .deactiveGray.withAlphaComponent(0.3)
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    private func selectView() {
        self.backgroundColor = .accent.withAlphaComponent(0.3)
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.accent.cgColor
    }
}

struct WordInfo: Hashable {
    let identifier: Int
    let word: String
}
