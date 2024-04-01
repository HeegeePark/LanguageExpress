//
//  RealmManager.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    private init() { }
    
    private let collectionRepository = CollectionRepository()
    private let phraseRepository = PhraseRepository()
    private let tagRepository = TagRepository()
    
    func loadCollection() -> [Collection] {
        return collectionRepository.fetch()
    }
    
    func completionRate(collection: Collection) -> Float {
        guard !collection.phrases.isEmpty else {
            return 0
        }
        let all = collection.phrases
        let completed = phraseRepository.fetchCompleted(list: all)
        return Float(completed.count) / Float(all.count)
    }
    
    func addCollection(name: String, color: String) {
        collectionRepository.createItem(
            Collection(name: name, color: color)
        )
    }
    
    func addPhrase(at collection: Collection, phrase: String, meaning: String, memo: String, tags: [String]) {
        // phrase create
        let phraseModel = Phrase(phrase: phrase,
                                 meaning: meaning,
                                 memo: !memo.isEmpty ? memo: nil)
        phraseRepository.createItem(phraseModel)
        
        // phrase에 tag append
        tags.forEach {
            let tag = tagRepository.loadTag(title: $0)
            phraseRepository.updateTag(item: phraseModel, tag: tag)
        }
        
        // collection에 phrase append
        collectionRepository.updatePhrase(item: collection, phrase: phraseModel)
    }
    
    func toggleIsBookMark(phrase: Phrase) {
        phraseRepository.updateIsBookMark(item: phrase)
    }
    
    func changeStateOfMemorization(phrase: Phrase) {
        let current = StateOfMemorization(rawValue: phrase.stateOfMemorizationRawValue)!
        let stateToChangeRawvalue = current.nextTypeRawvalue
        phraseRepository.updateStateOfMemorizationRawValue(item: phrase, rawvalue: stateToChangeRawvalue)
    }
    
    func deleteCollection(collection: Collection) {
        // collection에 포함된 phrase 지우기
        collection.phrases.forEach { phrase in
            phraseRepository.deleteItem(object: phrase)
        }
        collectionRepository.deleteItem(object: collection)
    }
    
    func deletePhrase(phrase: Phrase) {
        // TODO: 연결된 tag 없어질 때 tag도 삭제하기
        phraseRepository.deleteItem(object: phrase)
    }
    
    func tagList() -> [Tag] {
        return tagRepository.fetch()
    }
    
    func phraseList() -> [Phrase] {
        return phraseRepository.fetch()
    }
    
    func phraseListByTag(_ filterBookMark: Bool, tagList: [Tag]) -> [Phrase] {
        var result: Results<Phrase>?
        if filterBookMark {
            let predicate = "isBookMark == true"
            result = phraseRepository.filterByQuery(NSPredicate(format: predicate))
        }
        
        for tag in tagList {
            if result == nil {
                result = phraseRepository.fetchResults()
            }
            result = result!.where {
                $0.tags.contains(tag)
            }
        }
        
        return Array(result!)
    }
}
