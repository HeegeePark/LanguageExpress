//
//  Observable.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation

final class Observable<T> {
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)    // 초기화된 값 바로 실행
        self.closure = closure
    }
}

