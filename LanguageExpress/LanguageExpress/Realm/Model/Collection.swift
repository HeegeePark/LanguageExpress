//
//  Collection.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation
import RealmSwift

class Collection: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String   // 컬렉션 이름
    @Persisted var date: Date   // 등록 날짜
    @Persisted var color: String   // 컬러 hex코드
    @Persisted var phrases: List<Phrase>    // 구문 리스트
    
    convenience init(name: String, color: String) {
        self.init()
        self.name = name
        self.date = Date()
        self.color = color
    }
}
