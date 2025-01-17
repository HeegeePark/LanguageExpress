//
//  TabBarItem.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/25/24.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case phraseCollection
    case archive
    case setting
}

extension TabBarItem {
    private var deactiveIcon: UIImage? {
        switch self {
        case .phraseCollection:
            return .languageDeactive
        case .archive:
            return .settingDeactive
        case .setting:
            return .settingDeactive
        }
    }
    
    private var activeIcon: UIImage? {
        switch self {
        case .phraseCollection:
            return .languageActive
        case .archive:
            return .settingActive
        case .setting:
            return .settingActive
        
        }
    }
}

extension TabBarItem {
    public func asTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: nil,
            image: deactiveIcon,
            selectedImage: activeIcon
        )
    }
}
