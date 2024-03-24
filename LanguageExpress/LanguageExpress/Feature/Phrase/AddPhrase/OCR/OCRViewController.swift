//
//  OCRViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/24/24.
//

import UIKit
import PhotosUI

final class OCRViewController: BaseViewController {
    private let mainView = OCRView()
    
    override func loadView() {
        view = mainView
    }
    
    private let viewModel = OCRViewModel()
    private var input: OCRViewModel.Input!
    private var output: OCRViewModel.Output!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        input.viewDidLoadEvent.value = ()
    }
    
    private func bindViewModel() {
        input = OCRViewModel.Input(
            viewDidLoadEvent: Observable(nil),
            photoPickerButtonTappedEvent: Observable(nil),
            resetImageButtonTappedEvent: Observable(nil),
            imageSelectedEvent: Observable(nil)
        )
        
        output = viewModel.transform(from: input)
        
        output.presentPhotoPickerTrigger.bind { event in
            guard event != nil else { return }
            self.presentPicker()
        }
        
        output.resetImageTrigger.bind { event in
            guard event != nil else { return }
            self.mainView.resetImage()
        }
        
        output.textRecognitionTrigger.bind { [weak self] event in
            guard let self, event != nil else { return }
            
            let imageView = self.mainView.imageView
            OCRManager.shared.recognizeText(image: imageView.image,
                imageViewSize: imageView.frame.size) { results in
                guard !results.isEmpty else {
                    print(results)
                    self.showToast(Message.emptyTextRecognitionResult)
                    return
                }
                
                results.forEach { result in
                    self.mainView.drawTextArea(ocr: result)
                }
            }
        }
    }
    
    private func presentPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    override func configureView() {
        mainView.delegate = self
    }
    
    override func configureNavigationBar(_ style: NavigationBarStyle = .default) {
        super.configureNavigationBar(.ocr)
        navigationItem.title = "텍스트 인식"
        
        let dismiss = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(dismissButtonTapped)
        )
        navigationItem.leftBarButtonItem = dismiss
        
        let resetImage = UIBarButtonItem(
            title: "reset",
            style: .plain,
            target: self,
            action: #selector(resetImageButtonTapped)
        )
        navigationItem.rightBarButtonItem = resetImage
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func resetImageButtonTapped() {
        input.resetImageButtonTappedEvent.value = ()
    }
}

extension OCRViewController: OCRViewDelegate {
    func photoPickerButtonTapped() {
        input.photoPickerButtonTappedEvent.value = ()
    }
}

extension OCRViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProviders = results.map(\.itemProvider)
        
        if !itemProviders.isEmpty {
            displayImage(itemProviders)
        }
    }
    
    // delegate에 정의된 메소드는 아니지만 보기 쉽게 아래에 구현
    private func displayImage(_ itemProviders: [NSItemProvider]) {
        guard let itemProvider = itemProviders.first else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                
                guard let self, let image = image as? UIImage else { return }
                
                // loadObject는 비동기 작업이므로 메인스레드로 UI 작업
                DispatchQueue.main.async {
                    self.mainView.setImage(image)
                    self.input.imageSelectedEvent.value = ()
                }
            }
        }
    }
}

