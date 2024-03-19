//
//  Phrase.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation
import RealmSwift

class Phrase: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var phrase: String   // 구문
    @Persisted var meaning: String   // 구문 뜻
    @Persisted var memo: String?   // 메모
    @Persisted var date: Date   // 등록 날짜
    @Persisted var stateOfMemorizationRawValue: String // 암기 정도 enum rawvalue
    @Persisted var isBookMark: Bool   // 북마크 여부
    @Persisted var tags: List<Tag>    // 태그 리스트
    
    convenience init(phrase: String, meaning: String, memo: String?) {
        self.init()
        self.phrase = phrase
        self.meaning = meaning
        self.memo = memo
        self.date = Date()
        self.stateOfMemorizationRawValue = StateOfMemorization.hard.rawValue
        self.isBookMark = false
    }
}
