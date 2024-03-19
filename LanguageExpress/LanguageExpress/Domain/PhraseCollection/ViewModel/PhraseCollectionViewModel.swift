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
    }
    
    struct Output {
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.viewDidAppearEvent.bind { _ in
            self.loadCollectionFromRealm(output: output)
        }
        
        input.phraseCollectionViewCellDidSelectItemAtEvent.bind { idx in
            
        }
        
        return output
    }
    
    func loadCollectionFromRealm(output: Output) {
        // TODO: realm으로부터 컬렉션 정보 가져오기
    }
    
    func loadPhraseListFromRealm(collectionIndex idx: Int, output: Output) {
        // TODO: realm으로부터 컬렉션의 phrase list 가져오기
    }
}
