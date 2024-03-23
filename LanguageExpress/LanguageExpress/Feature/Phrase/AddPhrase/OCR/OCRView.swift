//
//  OCRView.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/24/24.
//

import UIKit
import SnapKit

protocol OCRViewDelegate: UIViewController {
    func photoPickerButtonTapped()
}

final class OCRView: BaseView {
    weak var delegate: OCRViewDelegate?
    
    private let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var photoPickerButton = {
        let view = UIButton()
        view.setTitle("텍스트 인식 이미지 고르기", for: .normal)
        view.titleLabel?.font = .sfPro14Bold
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .primary
        view.setCornerRadius(.medium)
        view.addTarget(self, action: #selector(photoPickerButtonTapped), for: .touchUpInside)
        return view
    }()
    
    @objc private func photoPickerButtonTapped() {
        delegate?.photoPickerButtonTapped()
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
        photoPickerButton.isEnabled = false
    }
    
    func resetImage() {
        imageView.image = nil
        photoPickerButton.isEnabled = true
    }
    
    override func configureHierarchy() {
        self.addSubview(photoPickerButton)
        self.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        photoPickerButton.snp.makeConstraints { make in
            make.center.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
}
