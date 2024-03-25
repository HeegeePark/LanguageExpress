//
//  OCRViewModel.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/24/24.
//

import Foundation

final class OCRViewModel: ViewModelAvailable {
    struct Input {
        var bindViewModelEvent: Observable<Collection>
        var photoPickerButtonTappedEvent: Observable<Void?>
        var resetImageButtonTappedEvent: Observable<Void?>
        var imageSelectedEvent: Observable<Void?>
        var selectedWordAppendedEvent: Observable<WordInfo?>
        var selectedWordRemovedEvent: Observable<WordInfo?>
        var doneButtonTappedEvent: Observable<Void?>
        var addPhraseCompletionHandlerEvent: Observable<String>
    }
    
    struct Output {
        var collection: Observable<Collection?> = Observable(nil)
        var presentPhotoPickerTrigger: Observable<Void?> = Observable(nil)
        var activateIndicatorTrigger: Observable<Bool> = Observable(false)
        var resetImageTrigger: Observable<Void?> = Observable(nil)
        var textRecognitionFinishedTrigger: Observable<Void?> = Observable(nil)
        var selectedWords: Observable<Set<WordInfo>> = Observable([])
        var combinedResult: Observable<String> = Observable("")
        var sendCombineResultTrigger: Observable<String> = Observable("")
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.bindViewModelEvent.bind { collection in
            self.loadCollection(collection: collection, output: output)
            output.presentPhotoPickerTrigger.value = ()
        }
        
        input.photoPickerButtonTappedEvent.bind { _ in
            output.presentPhotoPickerTrigger.value = ()
        }
        
        input.resetImageButtonTappedEvent.bind { _ in
            output.resetImageTrigger.value = ()
            output.selectedWords.value.removeAll()
            output.combinedResult.value.removeAll()
        }
        
        input.imageSelectedEvent.bind { event in
            guard event != nil else { return }
            output.activateIndicatorTrigger.value = true
        }
        
        input.selectedWordAppendedEvent.bind { wordInfo in
            guard let wordInfo else { return }
            self.appendSelectedWord(wordInfo: wordInfo, output: output)
        }
        
        input.selectedWordRemovedEvent.bind { wordInfo in
            guard let wordInfo else { return }
            self.removeSelectedWord(wordInfo: wordInfo, output: output)
        }
        
        input.doneButtonTappedEvent.bind { event in
            guard event != nil else { return }
            self.updateCombinedResult(output: output)
        }
        
        input.addPhraseCompletionHandlerEvent.bind { result in
            guard !result.isEmpty else { return }
            output.sendCombineResultTrigger.value = output.combinedResult.value
        }
        
        return output
    }
    
    private func loadCollection(collection: Collection, output: Output) {
        output.collection.value = collection
    }
    
    private func appendSelectedWord(wordInfo: WordInfo, output: Output) {
        output.selectedWords.value.insert(wordInfo)
    }
    
    private func removeSelectedWord(wordInfo: WordInfo, output: Output) {
        output.selectedWords.value.remove(wordInfo)
    }
    
    private func updateCombinedResult(output: Output) {
        let combined = output.selectedWords.value.sorted {
            $0.identifier < $1.identifier
        }.map(\.word).joined(separator: " ")
        output.combinedResult.value = combined
    }
}
