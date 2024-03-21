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
}
