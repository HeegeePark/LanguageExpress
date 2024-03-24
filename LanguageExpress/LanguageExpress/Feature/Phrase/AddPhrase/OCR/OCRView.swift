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
    func doneButtonTapped()
    func selectedWordAppended(wordInfo: WordInfo)
    func selectedWordRemoved(wordInfo: WordInfo)
}

final class OCRView: BaseView {
    weak var delegate: OCRViewDelegate?
    
    private let imageView = {
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
    
    private lazy var doneButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        let image = UIImage(systemName: "text.viewfinder", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.backgroundColor = .accent
        view.setShadow()
        view.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private var textAreaViews = [OCRTextAreaView]()
    private var image: UIImage? {
        didSet {
            if let image {
                imageView.image = image
                imageView.isUserInteractionEnabled = true
            } else {
                imageView.image = nil
                imageView.isUserInteractionEnabled = false
                removeTextAreaView()
            }
        }
    }
    
    func presentIndicator() {
        self.showIndicator()
    }
    
    func hideIndicator() {
        self.dismissIndicator()
    }
    
    @objc private func photoPickerButtonTapped() {
        delegate?.photoPickerButtonTapped()
    }
    
    @objc private func doneButtonTapped() {
        delegate?.doneButtonTapped()
    }
    
    func setImage(_ image: UIImage, completionHandler: @escaping (CGSize) -> Void) {
        self.image = image
        remkeImageViewLayout()
        completionHandler(imageView.frame.size)
    }
    
    func resetImage() {
        self.image = nil
        doneButton.isHidden = true
    }
    
    func drawTextArea(ocr: OCRResult, idx: Int) {
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
        
        let recognized = OCRTextAreaView(frame: invertedRect)
        recognized.setResult(text: ocr.text, idx: idx)
        recognized.delegate = self
        imageView.addSubview(recognized)
        textAreaViews.append(recognized)
    }
    
    func activateDoneButton() {
        doneButton.isHidden = false
    }
    
    private func remkeImageViewLayout() {
        guard let image else { return }
        let aspectRatio = image.size.width / image.size.height
        let scaledHeight = imageView.frame.width / aspectRatio
        
        imageView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(scaledHeight)
        }
        
        imageView.frame.size = CGSize(width: self.frame.width, height: scaledHeight)
    }
    
    private func removeTextAreaView() {
        textAreaViews.forEach {
            $0.removeFromSuperview()
        }
        textAreaViews.removeAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        doneButton.setCornerRadius(.circle(doneButton))
    }
    
    override func configureHierarchy() {
        self.addSubview(photoPickerButton)
        self.addSubview(imageView)
        self.addSubview(doneButton)
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
        
        doneButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(50)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .white
        doneButton.isHidden = true
    }
}

extension OCRView: OCRTextAreaViewDelegate {
    func viewSelected(wordInfo: WordInfo, isSelect: Bool) {
        if isSelect {
            delegate?.selectedWordAppended(wordInfo: wordInfo)
        } else {
            delegate?.selectedWordRemoved(wordInfo: wordInfo)
        }
    }
}
