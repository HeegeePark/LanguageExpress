//
//  TagRepository.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import Foundation
import RealmSwift

final class TagRepository: BaseRepository<Tag> {
    private let realm = try! Realm()
    
    func loadTag(title: String) -> Tag  {
        // 존재한다면 불러오고
        if let tag = realm.objects(Tag.self).filter("title == '\(title)'").first {
            return tag
        } else { // 없다면 create해서 반환
            let newTag = Tag(title: title)
            createItem(newTag)
            return newTag
        }
    }
}
