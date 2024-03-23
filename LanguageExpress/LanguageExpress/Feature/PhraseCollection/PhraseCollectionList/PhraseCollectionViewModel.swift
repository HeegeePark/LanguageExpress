//
//  PhraseCollectionViewModel.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation

final class PhraseCollectionViewModel: ViewModelAvailable {
    struct Input {
        var viewDidAppearEvent: Observable<Void?>
        var phraseCollectionViewCellDidSelectItemAtEvent: Observable<Int>
        var deleteCollectionAlertConfirmEvent: Observable<Int>
        var addFloatingButtonTappedEvent: Observable<Void?>
    }
    
    struct Output {
        var collections: Observable<[Collection]> = Observable([])
        var collectionToPush: Observable<Collection?> = Observable(nil)
        var addCollectionToPush: Observable<Void?> = Observable(nil)
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.viewDidAppearEvent.bind { _ in
            self.loadCollectionFromRealm(output: output)
        }
        
        input.phraseCollectionViewCellDidSelectItemAtEvent.bind { idx in
            let count = output.collections.value.count
            guard 0..<count ~= idx else { return }
            self.loadCollection(collectionIndex: idx, output: output)
        }
        
        input.deleteCollectionAlertConfirmEvent.bind { idx in
            let count = output.collections.value.count
            guard 0..<count ~= idx else { return }
            let collection = output.collections.value[idx]
            self.deleteCollection(collection: collection, output: output)
            self.loadCollectionFromRealm(output: output)
        }
        
        input.addFloatingButtonTappedEvent.bind { event in
            guard event != nil else { return }
            output.addCollectionToPush.value = ()
        }
        
        return output
    }
    
    func loadCollectionFromRealm(output: Output) {
        output.collections.value = RealmManager.shared.loadCollection()
    }
    
    func loadCollection(collectionIndex idx: Int, output: Output) {
        output.collectionToPush.value = output.collections.value[idx]
    }
    
    func deleteCollection(collection: Collection, output: Output) {
        RealmManager.shared.deleteCollection(collection: collection)
    }
}
