//
//  PhraseArchiveViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/26/24.
//

import UIKit
import SnapKit

final class PhraseArchiveViewController: BaseViewController {
    private var pagerTab: PagerTab!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setTagList()
    }
    
    func configure() {
        view.backgroundColor = .white
        pagerTab = PagerTab().then {
            view.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
    
    private func setTagList() {
        let viewControllers = getTagList().map {
            PhraseArchivePageViewController(type: $0)
        }
        let style = PagerTab.Style.default
        pagerTab.setup(self, viewControllers: viewControllers)
    }
    
    private func getTagList() -> [String] {
        return ["전체", "북마크", "영어", "여행", "유투브"]
    }

}
