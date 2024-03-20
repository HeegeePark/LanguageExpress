//
//  Tag.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation
import RealmSwift

class Tag: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String   // 태그 제목
    @Persisted var date: Date   // 등록 날짜
    
    convenience init(title: String) {
        self.init()
        self.title = title
        self.date = Date()
    }
}
