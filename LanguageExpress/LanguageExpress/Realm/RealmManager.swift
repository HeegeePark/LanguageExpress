//
//  RealmManager.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation

final class RealmManager {
    static let shared = RealmManager()
    
    private init() { }
    
    private let collectionRepository = CollectionRepository()
    private let phraseRepository = PhraseRepository()
    
    func loadCollection() -> [Collection] {
        return collectionRepository.fetch()
    }
    
    func completionRate(collection: Collection) -> Float {
        let all = collection.phrases
        let completed = phraseRepository.fetchFiltered(list: all, key: "stateOfMemorizationRawValue", value: StateOfMemorization.completed.rawValue)
        return Float(completed.count) / Float(all.count)
    }
}
