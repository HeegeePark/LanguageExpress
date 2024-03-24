//
//  OCRManager.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/24/24.
//

import UIKit
import VisionKit
import Vision

final class OCRManager {
    static let shared = OCRManager()
    private init() { }
    
    func recognizeText(image: UIImage?, imageViewSize: CGSize, completionHandler: @escaping ([OCRResult]) -> Void) {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
        }
        
        var results = [OCRResult]()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            
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
                                Int(imageViewSize.width),
                                Int(imageViewSize.height)
                            )
                            
                            results.append(OCRResult(bbox: boundingBox, text: String(word)))
                        }
                        
                        // 다음 단어 위치 update
                        currentIndex = wordRange.upperBound
                    }
                    return nil
                })
                // OCR 결과 반환
                completionHandler(results)
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
                // TODO: 지원 언어 추가해도 정확도가 높지 않아서 차후 정확도 높이기 대응할 것.
                request.recognitionLanguages = possibleLanguages
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

struct OCRResult {
    let bbox: CGRect
    let text: String
}
