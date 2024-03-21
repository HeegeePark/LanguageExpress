//
//  AddPhraseViewModel.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import Foundation

final class AddPhraseViewModel: ViewModelAvailable {
    struct Input {
        var bindViewModelEvent: Observable<Collection>
        var phraseChangedEvent: Observable<String>
        var meaningChangedEvent: Observable<String>
        var memoChangedEvent: Observable<String>
        var tagsChangedEvent: Observable<[String]>
        var addButtonTappedEvent: Observable<Void?>
    }
    
    struct Output {
        var collection: Observable<Collection?> = Observable(nil)
        var phrase: Observable<String> = Observable("")
        var meaning: Observable<String> = Observable("")
        var memo: Observable<String> = Observable("")
        var tags: Observable<[String]> = Observable([])
        var failureToAddPhraseTrigger: Observable<String> = Observable("")
        var successToAddPhraseTrigger: Observable<Void?> = Observable(nil)
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.bindViewModelEvent.bind { collection in
            self.loadCollection(collection: collection, output: output)
        }
        
        input.phraseChangedEvent.bind { phrase in
            self.updatePhrase(phrase: phrase, output: output)
        }
        
        input.meaningChangedEvent.bind { meaning in
            self.updateMeaning(meaning: meaning, output: output)
        }
        
        input.memoChangedEvent.bind { memo in
            self.updateMemo(memo: memo, output: output)
        }
        
        input.tagsChangedEvent.bind { tags in
            self.updateTags(tags: tags, output: output)
        }
        
        input.addButtonTappedEvent.bind { event in
            guard event != nil else { return }
            guard self.validateToAddPhrase(output: output) else {
                output.failureToAddPhraseTrigger.value = Message.fillInRequired
                return
            }
            
            self.addPhrase(output: output)
        }
        
        return output
    }
    
    private func loadCollection(collection: Collection, output: Output) {
        output.collection.value = collection
    }
    
    private func updatePhrase(phrase: String, output: Output) {
        output.phrase.value = phrase
    }
    
    private func updateMeaning(meaning: String, output: Output) {
        output.meaning.value = meaning
    }
    
    private func updateMemo(memo: String, output: Output) {
        output.memo.value = memo
    }
    
    private func updateTags(tags: [String], output: Output) {
        output.tags.value = tags
    }
    
    private func validateToAddPhrase(output: Output) -> Bool {
        return !output.phrase.value.isEmpty &&
                !output.meaning.value.isEmpty
    }
    
    private func addPhrase(output: Output) {
        guard let collection = output.collection.value else {
            output.failureToAddPhraseTrigger.value = Message.emptyCollection
            return
        }
        let phrase = output.phrase.value
        let meaning = output.meaning.value
        let memo = output.memo.value
        let tags = output.tags.value
        RealmManager.shared.addPhrase(
            at: collection,
            phrase: phrase,
            meaning: meaning,
            memo: memo,
            tags: tags
        )
        output.successToAddPhraseTrigger.value = ()
    }
}
