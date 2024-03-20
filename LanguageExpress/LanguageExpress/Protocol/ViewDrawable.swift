//
//  ViewDrawable.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/18/24.
//

import Foundation

protocol ViewDrawable: NSObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}
