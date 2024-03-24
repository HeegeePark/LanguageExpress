//
//  ResultSheetViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit
import SnapKit

final class ResultSheetViewController: BaseViewController {
    private let titleLabel = {
       let view = UILabel()
        view.text = "인식된 텍스트"
        view.font = .sfPro17Bold
        view.textColor = .primary
        return view
    }()
    
    private let resultLabel = {
       let view = UILabel()
        view.font = .sfPro14Bold
        view.textColor = .black
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var addPhraseButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        var subtitleAttr = AttributedString.init("추가")
        subtitleAttr.font = .sfPro12Bold
        config.attributedSubtitle = subtitleAttr
        config.baseBackgroundColor = .primary
        config.baseForegroundColor = .white
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 10
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(addPhraseButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private var result = ""
    
    var addPhraseCompletionHandler: ((String) -> Void)?
    
    @objc private func addPhraseButtonTapped() {
        dismiss(animated: true)
        addPhraseCompletionHandler?(result)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .sheetBackground
    }
    
    func setPhrase(result: String) {
        self.result = result
    }
    
    override func configureHierarchy() {
        [titleLabel, resultLabel, addPhraseButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(addPhraseButton.snp.leading).offset(20)
            make.bottom.greaterThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        addPhraseButton.snp.makeConstraints { make in
            make.trailing.equalTo(titleLabel)
            make.verticalEdges.equalTo(resultLabel)
            make.width.equalTo(70)
        }
    }
    
    override func configureView() {
        resultLabel.text = result
    }
}
