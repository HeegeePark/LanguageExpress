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
    
    func loadCollection() -> [Collection] {
        return collectionRepository.fetch()
    }
}
