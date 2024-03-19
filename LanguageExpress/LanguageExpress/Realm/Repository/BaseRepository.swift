//
//  BaseRepository.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation
import RealmSwift

class BaseRepository<T: Object> {
    typealias Model = T
    private let realm = try! Realm()
    
    func createItem(_ item: Model) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
            // TODO: 에러 핸들링
        }
    }
    
    func fetch() -> [Model] {
        return Array(realm.objects(Model.self))
    }
    
    func updateItem(id: ObjectId, updated: Model) {
    }
    
    func deleteItem(object: ObjectBase) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error)
        }
    }
}

