//
//  CustomAlertViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import UIKit
import SnapKit

final class CustomAlertViewController: BaseViewController {
    var message: String?
    var addActionConfirm: AddAction?
    var showCancel: Bool = true
    
    private var alertView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private lazy var messageLabel = {
        let label = UILabel()
        label.font = .sfPro13Regular
        label.textAlignment = .center
        label.text = message
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton = {
        let button = UIButton()
        button.setTitleColor(.deactiveGray, for: .normal)
        button.titleLabel?.font = .sfPro12Bold
        button.setTitle("취소", for: .normal)
        button.setCornerRadius(.large)
        button.layer.borderColor = UIColor.deactiveGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .sfPro12Bold
        button.setTitle(addActionConfirm?.text, for: .normal)
        button.setCornerRadius(.large)
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .primary
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if sender == confirmButton {
            addActionConfirm?.action?()
        }
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        view.addSubview(alertView)
        [messageLabel, cancelButton, confirmButton].forEach {
            alertView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        alertView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.center.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.width.equalTo(260)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(30)
            make.width.equalTo(125)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.equalTo(cancelButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.top.equalTo(cancelButton)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func remakeConfirmButtonLayout() {
        confirmButton.snp.remakeConstraints { make in
            make.horizontalEdges.equalTo(messageLabel)
            make.height.equalTo(40)
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .deactiveGray.withAlphaComponent(0.5)
        if !showCancel {
            cancelButton.isHidden = !showCancel
            remakeConfirmButtonLayout()
        }
    }
}
