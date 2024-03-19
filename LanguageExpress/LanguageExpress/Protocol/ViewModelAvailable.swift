//
//  ViewModelAvailable.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/19/24.
//

import Foundation

protocol ViewModelAvailable {
    associatedtype Input
    associatedtype Output
    func transform(from input: Input) -> Output
}
