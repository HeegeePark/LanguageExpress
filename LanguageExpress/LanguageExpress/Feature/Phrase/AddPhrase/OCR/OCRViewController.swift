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
    }
    
    func bindViewModel(collection: Collection) {
        input = OCRViewModel.Input(
            bindViewModelEvent: Observable(collection),
            photoPickerButtonTappedEvent: Observable(nil),
            resetImageButtonTappedEvent: Observable(nil),
            imageSelectedEvent: Observable(nil),
            selectedWordAppendedEvent: Observable(nil),
            selectedWordRemovedEvent: Observable(nil),
            doneButtonTappedEvent: Observable(nil),
            addPhraseCompletionHandlerEvent: Observable("")
        )
        
        output = viewModel.transform(from: input)
        
        output.presentPhotoPickerTrigger.bind { event in
            guard event != nil else { return }
            self.presentPicker()
        }
        
        output.activateIndicatorTrigger.bind { isActive in
            if isActive {
                self.mainView.presentIndicator()
            } else {
                self.mainView.hideIndicator()
            }
        }
        
        output.resetImageTrigger.bind { event in
            guard event != nil else { return }
            self.mainView.resetImage()
        }
        
        output.textRecognitionFinishedTrigger.bind { [weak self] event in
            guard let self, event != nil else { return }
            self.mainView.hideIndicator()
        }
        
        output.combinedResult.bind { result in
            guard !result.isEmpty else { return }
            self.presentResultSheetVC(result)
        }
        
        output.sendCombineResultTrigger.bind { result in
            guard !result.isEmpty else { return }
            let addVC = AddPhraseViewController()
            addVC.bindViewModel(collection: collection)
            addVC.setTextRecognitionResult(result: result)
            let nav = UINavigationController(rootViewController: addVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    private func presentResultSheetVC(_ result: String) {
        let resultSheetVC = ResultSheetViewController()
        resultSheetVC.setPhrase(result: result)
        
        resultSheetVC.addPhraseCompletionHandler = { [weak self] result in
            guard let self else { return }
            self.input.addPhraseCompletionHandlerEvent.value = result
        }
        
        let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
            
            return 150 - safeAreaBottom
        }
        
        if let sheet = resultSheetVC.sheetPresentationController {
            sheet.detents = [customDetent]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        
        present(resultSheetVC, animated: true)
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
        super.configureNavigationBar(.add)
        navigationItem.title = "텍스트 인식"
        
        let dismiss = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(dismissButtonTapped)
        )
        navigationItem.leftBarButtonItem = dismiss
        
        let resetImage = UIBarButtonItem(
            title: "리셋",
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
    
    func doneButtonTapped() {
        input.doneButtonTappedEvent.value = ()
    }
    
    func selectedWordAppended(wordInfo: WordInfo) {
        input.selectedWordAppendedEvent.value = wordInfo
    }
    
    func selectedWordRemoved(wordInfo: WordInfo) {
        input.selectedWordRemovedEvent.value = wordInfo
    }
}

extension OCRViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) {
            // 취소했을 때
            if results.isEmpty {
                self.mainView.hideIndicator()
            }
        }
        
        let itemProviders = results.map(\.itemProvider)
        
        if !itemProviders.isEmpty {
            displayImage(itemProviders)
            input.imageSelectedEvent.value = ()
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
                    self.mainView.setImage(image) { size in
                        OCRManager.shared.recognizeText(image: image,
                            imageViewSize: size) { results in
                            guard !results.isEmpty else {
                                self.showToast(Message.emptyTextRecognitionResult)
                                self.output.textRecognitionFinishedTrigger.value = ()
                                return
                            }
                            
                            results.enumerated().forEach { (idx, result) in
                                self.mainView.drawTextArea(ocr: result, idx: idx)
                            }
                            self.output.textRecognitionFinishedTrigger.value = ()
                            self.mainView.activateDoneButton()
                        }
                    }
                }
            }
        }
    }
}

