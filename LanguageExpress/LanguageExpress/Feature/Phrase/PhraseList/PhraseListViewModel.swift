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
        var tagButtonTappedEvent: Observable<String>
        var phraseCollectionViewCellDidSelectItemAtEvent: Observable<Int>
    }
    
    struct Output {
        var collectionName: Observable<String> = Observable("")
        var phrases: Observable<[Phrase]> = Observable([])
    }

    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.bindViewModelEvent.bind { collection in
            self.loadCollectionName(collection: collection, output: output)
            self.loadPhraseList(collection: collection, output: output)
            // TODO: 태그 버튼에 쓸 전체 태그 불러오기
        }
        
        return output
    }
    
    func loadCollectionName(collection: Collection, output: Output) {
        output.collectionName.value = collection.name
    }
    
    func loadPhraseList(collection: Collection, output: Output) {
        output.phrases.value = Array(collection.phrases)
    }
}
