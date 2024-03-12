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

final class VisionKitViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "test")
        imageView.contentMode = .scaleAspectFit
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
    
    func drawTextArea(text: String, bbox: CGRect) -> UIView {
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
        let invertedY = imageSize.height - (rect.origin.y + rect.height)
        let invertedRect = CGRect(
            x: rect.minX,
            y: invertedY,
            width: rect.width,
            height: rect.height
        )
        let recognized = UIView(frame: invertedRect)
        imageView.addSubview(recognized)
        recognized.backgroundColor = .red.withAlphaComponent(0.3)
        return recognized
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
                // 텍스트 인식 area 표시
                let _ = observations.compactMap({
                    let topCandidate = $0.topCandidates(1).first
                    return self?.drawTextArea(text: topCandidate!.string, bbox: $0.boundingBox)
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
