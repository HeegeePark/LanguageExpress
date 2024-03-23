//
//  TipViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/23/24.
//

import UIKit

final class TipViewController: BaseViewController {
    var image: UIImage?
    var tipTitle: String?
    var message: String?

    private var tipView = {
        let view = UIView()
        view.setCornerRadius(.medium)
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private lazy var imageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = image
        return view
    }()
    
    private lazy var tipTitleLabel = {
        let view = UILabel()
        view.font = .sfPro14Bold
        view.textColor = .primary
        view.text = tipTitle
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var messageLabel = {
        let view = UILabel()
        view.font = .sfPro13Regular
        view.text = message
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var doneButton = {
        let view = UIButton()
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .sfPro12Bold
        view.setTitle("확인", for: .normal)
        view.setCornerRadius(.large)
        view.layer.borderColor = UIColor.primary.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .primary
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return view
    }()
    
    @objc private func buttonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        view.addSubview(tipView)
        [imageView, tipTitleLabel, messageLabel, doneButton].forEach {
            tipView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        tipView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(130)
        }
        
        tipTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(imageView)
            make.leading.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(30)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.width.equalTo(imageView)
            make.leading.equalTo(imageView)
            make.top.equalTo(tipTitleLabel.snp.bottom).offset(20)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(30)
            make.trailing.equalTo(imageView)
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .deactiveGray.withAlphaComponent(0.5)
    }
}
