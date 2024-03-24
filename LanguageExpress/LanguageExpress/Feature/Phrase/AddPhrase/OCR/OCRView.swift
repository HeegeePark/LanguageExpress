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

final class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var text: String?
}

final class OCRView: BaseView {
    weak var delegate: OCRViewDelegate?
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
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
    
    func drawTextArea(ocr: OCRResult) {
        // boundingBox는 전처리된 이미지 기반 정규화된 사이즈에
        // Quartz 좌표계를 따름(왼쪽 하단 모서리가 (0,0))
        // UIKit 좌표계와 이미지뷰 크기에 맞는 rect 구하기
        let imageSize: CGSize = imageView.frame.size
        let invertedY = imageSize.height - (ocr.bbox.origin.y + ocr.bbox.height)
        let invertedRect = CGRect(
            x: ocr.bbox.minX,
            y: invertedY,
            width: ocr.bbox.width,
            height: ocr.bbox.height
        )
        
        let recognized = UIView(frame: invertedRect)
        imageView.addSubview(recognized)
        recognized.backgroundColor = .red.withAlphaComponent(0.3)
        
        let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(textAreaTapped))
        tapGesture.text = ocr.text
        recognized.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textAreaTapped(_ sender: CustomTapGestureRecognizer) {
        print(sender.text!)
    }
    
    override func configureHierarchy() {
        self.addSubview(photoPickerButton)
        self.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(UIScreen.main.bounds.minX)
            make.horizontalEdges.bottom.equalToSuperview()
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
