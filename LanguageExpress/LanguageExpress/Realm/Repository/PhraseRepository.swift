//
//  PhraseRepository.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation
import RealmSwift

final class PhraseRepository: BaseRepository<Phrase> {
    private let realm = try! Realm()
    
    func fetchCompleted(list: List<Phrase>) -> [Phrase] {
        return Array(list.filter("stateOfMemorizationRawValue == %i", StateOfMemorization.completed.rawValue))
    }
    
    func updateTag(item: Phrase, tag: Tag) {
        do {
            try realm.write {
                item.tags.append(tag)
            }
        } catch {
            print("error")
        }
    }
    
    func updateIsBookMark(item: Phrase) {
        do {
            try realm.write {
                item.isBookMark.toggle()
            }
        } catch {
            print("error")
        }
    }
    
    func updateStateOfMemorizationRawValue(item: Phrase, rawvalue: Int) {
        do {
            try realm.write {
                item.stateOfMemorizationRawValue = rawvalue
            }
        } catch {
            print("error")
        }
    }
}
