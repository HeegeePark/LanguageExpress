//
//  PhraseListViewModel.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/21/24.
//

import Foundation

final class PhraseListViewModel: ViewModelAvailable {
    struct Input {
        var bindViewModelEvent: Observable<Collection>
        var viewDidAppearEvent: Observable<Void?>
//        var tagButtonTappedEvent: Observable<String>
        var phraseCollectionViewCellDidSelectItemAtEvent: Observable<Int>
        var phraseCollectionViewCellBookMarkButtonTappedEvent: Observable<Int>
        var phraseCollectionViewCellStateOfMemorizationButtonTappedEvent: Observable<Int>
        var addFloatingButtonTappedEvent: Observable<Int>
        var deletePhraseAlertConfirmEvent: Observable<Int>
    }
    
    struct Output {
        var collection: Observable<Collection?> = Observable(nil)
        var phrases: Observable<[Phrase]> = Observable([])
        var presentAddPhraseTrigger: Observable<Void?> = Observable(nil)
        var presentAddPhraseWithOCRTrigger: Observable<Void?> = Observable(nil)
        var successToToggleIsBookMarkTrigger: Observable<Void?> = Observable(nil)
        var successToChangeStateOfMemorizationTrigger: Observable<Void?> = Observable(nil)
    }

    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.bindViewModelEvent.bind { collection in
            self.loadCollection(collection: collection, output: output)
            self.loadPhraseList(collection: collection, output: output)
            // TODO: 태그 버튼에 쓸 전체 태그 불러오기
        }
        
        input.viewDidAppearEvent.bind { event in
            guard event != nil else { return }
            self.loadPhraseList(collection: output.collection.value!, output: output)
            // TODO: 태그 버튼에 쓸 전체 태그 불러오기
        }
        
        input.phraseCollectionViewCellDidSelectItemAtEvent.bind { idx in
            // TODO: meaningLabel isHidden 컨트롤
        }
        
        input.phraseCollectionViewCellBookMarkButtonTappedEvent.bind { idx in
            guard 0..<output.phrases.value.count ~= idx else { return }
            let phrase = output.phrases.value[idx]
            self.toggleIsBookMark(phrase: phrase, output: output)
        }
        
        input.phraseCollectionViewCellStateOfMemorizationButtonTappedEvent.bind { idx in
            guard 0..<output.phrases.value.count ~= idx else { return }
            let phrase = output.phrases.value[idx]
            self.changeStateOfMemorization(phrase: phrase, output: output)
        }
        
        input.addFloatingButtonTappedEvent.bind { sender in
            guard sender >= 0 else { return }
            if sender == 0 {
                output.presentAddPhraseTrigger.value = ()
            } else {
                output.presentAddPhraseWithOCRTrigger.value = ()
            }
        }
        
        input.deletePhraseAlertConfirmEvent.bind { idx in
            guard 0..<output.phrases.value.count ~= idx else { return }
            let phrase = output.phrases.value[idx]
            self.deletePhrase(phrase: phrase, output: output)
            self.loadPhraseList(collection: output.collection.value!, output: output)
        }
        
        return output
    }
    
    func loadCollection(collection: Collection, output: Output) {
        output.collection.value = collection
    }
    
    func loadPhraseList(collection: Collection, output: Output) {
        output.phrases.value = Array(collection.phrases)
    }
    
    func toggleIsBookMark(phrase: Phrase, output: Output) {
        RealmManager.shared.toggleIsBookMark(phrase: phrase)
        output.successToToggleIsBookMarkTrigger.value = ()
    }
    
    func changeStateOfMemorization(phrase: Phrase, output: Output) {
        RealmManager.shared.changeStateOfMemorization(phrase: phrase)
        output.successToChangeStateOfMemorizationTrigger.value = ()
    }
    
    func deletePhrase(phrase: Phrase, output: Output) {
        RealmManager.shared.deletePhrase(phrase: phrase)
    }
}
