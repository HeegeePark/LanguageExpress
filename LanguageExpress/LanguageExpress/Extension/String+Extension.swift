//
//  String+Extension.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import Foundation

extension String {
    var whiteSpaceRemoved: String {
        self.replacingOccurrences(of: " ", with: "")
    }
}
