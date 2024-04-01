//
//  PhraseArchiveView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/30/24.
//

import UIKit
import Then
import SnapKit

protocol PhraseArchiveViewDelegate: UIViewController {
    func seledcted(at idx: Int)
    func deSeledcted(at idx: Int)
}

final class PhraseArchiveView: BaseView {
    weak var delegate: PhraseArchiveViewDelegate?
    private var style = Style.default
    private var tabButtons = [UIButton]()
    private var selectedIndexs: Set<Int> = [] {
        didSet {
            updateTabButtons()
        }
    }
    
    private let horizontalScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let leadingSpacingView = UIView()
    
    private let tabStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.backgroundColor = .clear
    }

    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.backgroundColor = .clear
    }
    
    private let phraseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionView.phraseLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.register(PhraseListCollectionViewCell.self, forCellWithReuseIdentifier: "phraseList")
    }
    
    func setCollectionViewDelegate(target: UIViewController & UICollectionViewDelegate & UICollectionViewDataSource) {
        phraseCollectionView.delegate = target
        phraseCollectionView.dataSource = target
    }
    
    func reloadCollectionView() {
        phraseCollectionView.reloadData()
    }
    
    func setup(titles: [String]) {
        tabButtons = titles.enumerated().map { index, title in
            let button = setButton(width: buttonWidth(text: title))
            button.setTitle(title, for: .normal)
            button.tag = index
            return button
        }
        
        tabButtons.forEach { button in
            titleStackView.addArrangedSubview(button)
        }
        
        updateTabButtons()
    }
    
    func removeTabButtons() {
        for view in titleStackView.arrangedSubviews {
            if let button = view as? UIButton {
                titleStackView.removeArrangedSubview(button)
                button.removeFromSuperview()
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        if selectedIndexs.contains(index) {
            selectedIndexs.remove(index)
            delegate?.deSeledcted(at: index)
        } else {
            selectedIndexs.insert(index)
            delegate?.seledcted(at: index)
        }
    }
    
    private func updateTabButtons() {
        tabButtons.enumerated().forEach { index, button in
            let isSelected = selectedIndexs.contains(index)
            if isSelected {
                button.setTitleColor(style.titleActiveColor, for: .normal)
                button.backgroundColor = style.buttonBackgroundActiveColor
                button.setShadow(color: style.buttonShadowColor, opacity: style.buttonShadowOpacity)
                button.setBorder(color: style.buttonBackgroundActiveColor)
            } else {
                button.setTitleColor(style.titleDefaultColor, for: .normal)
                button.backgroundColor = style.buttonBackgroundDefaultColor
                button.removeShadow()
                button.setBorder(color: style.titleDefaultColor)
            }
        }
    }
    
    private func setButton(width: CGFloat) -> UIButton {
        return UIButton().then {
            $0.titleLabel?.font = style.titleDefaultFont
            $0.setTitleColor(style.titleDefaultColor, for: .normal)
            $0.setTitleColor(style.titleActiveColor, for: .selected)
            $0.layer.cornerRadius = 16
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            $0.titleLabel?.sizeToFit()
            
            $0.snp.makeConstraints() {
                let inset: CGFloat = 16
                $0.width.equalTo(inset * 2 + width)
            }
        }
    }
    
    private func buttonWidth(text: String) -> CGFloat {
        let label = UILabel().then {
            $0.font = style.titleDefaultFont
            $0.text = text
            $0.sizeToFit()
        }
        
        return label.frame.width
    }
    
    override func configureHierarchy() {
        addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(tabStackView)
        tabStackView.addArrangedSubview(leadingSpacingView)
        tabStackView.addArrangedSubview(titleStackView)
        addSubview(phraseCollectionView)
    }
    
    override func configureLayout() {
        horizontalScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.center.width.equalToSuperview()
            make.height.equalTo(100)
        }
        
        tabStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        leadingSpacingView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(10)
        }
        
        tabStackView.setCustomSpacing(0, after: tabStackView.subviews[1])
        
        phraseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .white
    }
}

extension PhraseArchiveView {
    struct Style {
        var buttonBackgroundActiveColor: UIColor
        var buttonBackgroundDefaultColor: UIColor
        var buttonHeight: CGFloat
        
        var buttonShadowOpacity: Float
        var buttonShadowColor: UIColor
        var buttonShadowOffset: CGSize

        var titleActiveColor: UIColor
        var titleDefaultColor: UIColor
        var titleActiveFont: UIFont
        var titleDefaultFont: UIFont

        static var `default` = Style(
            buttonBackgroundActiveColor: .primary,
            buttonBackgroundDefaultColor: .clear,
            buttonHeight: 32.0,
            buttonShadowOpacity: 0.2,
            buttonShadowColor: .primary,
            buttonShadowOffset: CGSize(width: 5, height: 5),
            titleActiveColor: .white,
            titleDefaultColor: .deactiveGray,
            titleActiveFont: .sfPro15Regular,
            titleDefaultFont: .sfPro15Regular
        )
    }
}
