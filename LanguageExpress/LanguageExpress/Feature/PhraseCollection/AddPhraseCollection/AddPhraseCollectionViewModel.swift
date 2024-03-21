//
//  AddPhraseCollectionViewModel.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/20/24.
//

import Foundation

final class AddPhraseCollectionViewModel: ViewModelAvailable {
    struct Input {
        var collectionNameChangedEvent: Observable<String>
        var collectionColorChangedEvent: Observable<String>
        var addButtonTappedEvent: Observable<Void?>
    }
    
    struct Output {
        var collectionName: Observable<String> = Observable("")
        var collectionColor: Observable<String> = Observable("")
        var failureToAddCollectionTrigger: Observable<String> = Observable("")
        var successToAddCollectionTrigger: Observable<Void?> = Observable(nil)
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.collectionNameChangedEvent.bind { name in
            self.updateCollectionName(name: name, output: output)
        }
        
        input.collectionColorChangedEvent.bind { color in
            self.updateCollectionColor(color: color, output: output)
        }
        
        input.addButtonTappedEvent.bind { event in
            guard event != nil else { return }
            guard self.validateToAddCollection(output: output) else {
                output.failureToAddCollectionTrigger.value = Message.fillInRequired
                return
            }
            
            self.addCollection(output: output)
            output.successToAddCollectionTrigger.value = ()
        }
        
        return output
    }
    
    private func updateCollectionName(name: String, output: Output) {
        output.collectionName.value = name
    }
    
    private func updateCollectionColor(color: String, output: Output) {
        output.collectionColor.value = color
    }
    
    private func validateToAddCollection(output: Output) -> Bool {
        return !output.collectionName.value.isEmpty &&
                !output.collectionColor.value.isEmpty
    }
    
    private func addCollection(output: Output) {
        let name = output.collectionName.value
        let color = output.collectionColor.value
        RealmManager.shared.addCollection(name: name, color: color)
    }
}
