//
//  OCRViewModel.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/24/24.
//

import Foundation

final class OCRViewModel: ViewModelAvailable {
    struct Input {
        var viewDidLoadEvent: Observable<Void?>
        var photoPickerButtonTappedEvent: Observable<Void?>
        var resetImageButtonTappedEvent: Observable<Void?>
        var imageSelectedEvent: Observable<Void?>
    }
    
    struct Output {
        var presentPhotoPickerTrigger: Observable<Void?> = Observable(nil)
        var resetImageTrigger: Observable<Void?> = Observable(nil)
        var textRecognitionTrigger: Observable<Void?> = Observable(nil)
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent.bind { _ in
            output.presentPhotoPickerTrigger.value = ()
        }
        
        input.photoPickerButtonTappedEvent.bind { _ in
            output.presentPhotoPickerTrigger.value = ()
        }
        
        input.resetImageButtonTappedEvent.bind { _ in
            output.resetImageTrigger.value = ()
        }
        
        input.imageSelectedEvent.bind { event in
            guard event != nil else { return }
            output.textRecognitionTrigger.value = ()
        }
        
        return output
    }
}
