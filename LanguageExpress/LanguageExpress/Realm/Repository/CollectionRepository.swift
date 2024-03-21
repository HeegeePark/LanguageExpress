//
//  CollectionRepository.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation
import RealmSwift

final class CollectionRepository: BaseRepository<Collection> {
    private let realm = try! Realm()
    
    func updatePhrase(item: Collection, phrase: Phrase) {
        do {
            try realm.write {
                item.phrases.append(phrase)
            }
        } catch {
            print("error")
        }
    }
}
