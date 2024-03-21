//
//  TagView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import UIKit

final class TagView: BaseView {
    private let titleView = {
        let view = UILabel()
        view.font = .sfPro15Regular
        view.textColor = .subtitle
        view.backgroundColor = .accent
        view.textAlignment = .center
        view.setCornerRadius(.small)
        return view
    }()
    
    private lazy var removeButton = {
        let view = UIButton()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.backgroundColor = .primary
        view.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return view
    }()
    
    var removeButtonTappedHandler: (() -> Void)?
    
    @objc private func removeButtonTapped() {
        removeButtonTappedHandler?()
    }
    
    func setTitle(_ title: String) {
        titleView.text = "#" + title.whiteSpaceRemoved
    }
    
    func titleViewWidth() -> CGFloat {
        titleView.sizeToFit()
        return titleView.frame.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        removeButton.setCornerRadius(.circle(removeButton))
    }
    
    override func configureHierarchy() {
        [titleView, removeButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            let offset: CGFloat = 10
            make.trailing.equalTo(titleView).offset(offset - 3)
            make.bottom.equalTo(titleView.snp.top).offset(offset + 3)
            make.size.equalTo(20)
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
    }
}
