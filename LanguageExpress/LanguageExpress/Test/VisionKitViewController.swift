//
//  VisionKitViewController.swift
//  week11Launch
//
//  Created by 박희지 on 3/7/24.
//

import UIKit
import VisionKit
import Vision
import SnapKit

final class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var text: String?
}

final class VisionKitViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "test")
        imageView.contentMode = .scaleAspectFit
        // 이미지뷰 하위의 텍스트 영역(UIView) 인터랙션이 가능하기 위해
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var rects: [CGRect] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recognizeText(image: imageView.image)
    }
    
    func drawTextArea(text: String, bbox: CGRect) {
        // boundingBox는 전처리된 이미지 기반 정규화된 사이즈에
        // Quartz 좌표계를 따름(왼쪽 하단 모서리가 (0,0))
        // UIKit 좌표계와 이미지뷰 크기에 맞는 rect 구하기
        let imageSize: CGSize = imageView.frame.size
        let rect = CGRect(
            x: bbox.origin.x * imageSize.width,
            y: bbox.origin.y * imageSize.height,
            width: bbox.width * imageSize.width,
            height: bbox.height * imageSize.height
        )
        
        let invertedY = imageSize.height - (bbox.origin.y + bbox.height)
        let invertedRect = CGRect(
            x: bbox.minX,
            y: invertedY,
            width: bbox.width,
            height: bbox.height
        )
        
        let recognized = UIView(frame: invertedRect)
        imageView.addSubview(recognized)
        recognized.backgroundColor = .red.withAlphaComponent(0.3)
        
        let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(textAreaTapped))
        tapGesture.text = text
        recognized.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textAreaTapped(_ sender: CustomTapGestureRecognizer) {
        print(sender.text!)
    }
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let _: [UIView] = observations.compactMap({
                    guard let topCandidate = $0.topCandidates(1).first else {
                        return nil
                    }
                    
                    // 복수 개의 단어가 인식될 경우, 단어 단위로 자르기
                    let words = topCandidate.string.split(separator: " ")
                    
                    // 동일한 순서의 글자(중복단어)가 있을 경우, 각 단어별로 고유한 좌표 세팅
                    var currentIndex = topCandidate.string.startIndex
                    
                    for word in words {
                        guard let wordRange = topCandidate.string.range(of: String(word), range: currentIndex..<topCandidate.string.endIndex) else {
                            continue
                        }
                        
                        // 단어의 range에 따른 새로운 boundingBox 계산
                        if let box = try? topCandidate.boundingBox(for: wordRange) {
                            let boundingBox = VNImageRectForNormalizedRect(
                                box.boundingBox,
                                Int(self?.imageView.frame.width ?? 0),
                                Int(self?.imageView.frame.height ?? 0)
                            )
                            
                            // 텍스트 인식 area 표시
                            self?.drawTextArea(text: String(word), bbox: boundingBox)
                        }
                        
                        // 다음 단어 위치 update
                        currentIndex = wordRange.upperBound
                    }
                    return nil
                })
            }
        }
        
        if #available(iOS 16.0, *) {
            let revision3 = VNRecognizeTextRequestRevision3
            request.revision = revision3
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US"]
            request.minimumTextHeight = 0.01
            request.usesLanguageCorrection = true
            
            do {
                var possibleLanguages: Array<String> = []
                possibleLanguages = try request.supportedRecognitionLanguages()
                print(possibleLanguages)
            } catch {
                print("Error getting the supported languages.")
            }
        } else {
            // Fallback on earlier versions
            request.recognitionLanguages =  ["en-US"]
            request.usesLanguageCorrection = true
        }
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}
