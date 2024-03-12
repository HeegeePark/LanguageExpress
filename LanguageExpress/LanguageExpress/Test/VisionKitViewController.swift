//
//  VisionKitViewController.swift
//  week11Launch
//
//  Created by 박희지 on 3/7/24.
//

import UIKit
import VisionKit
import Vision

class VisionKitViewController: UIViewController {
    
    private let label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "test")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
    
    var rects: [CGRect] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(imageView)
        recognizeText(image: imageView.image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40)
        
        label.frame = CGRect(
            x: 20,
            y: view.frame.size.width + view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: 300)
    }
    
    func drawTextArea() {
        rects.forEach { rect in
            let textArea = UIView(frame: rect)
            imageView.addSubview(textArea)
            textArea.backgroundColor = .red
        }
    }
    
    fileprivate func recognizeText(image: UIImage?){
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap({
                let topCandidate = $0.topCandidates(1).first
                print($0.boundingBox)
                self?.rects.append($0.boundingBox)
                
                return topCandidate?.string
            }).joined(separator: "\n")
            
            DispatchQueue.main.async {
                self?.label.text = text
                
                self?.drawTextArea()
            }
        }
        
        if #available(iOS 16.0, *) {
            let revision3 = VNRecognizeTextRequestRevision3
            request.revision = revision3
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["ko-KR"]
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
        
        do{
            try handler.perform([request])
        } catch {
            label.text = "\(error)"
            print(error)
        }
    }
}
