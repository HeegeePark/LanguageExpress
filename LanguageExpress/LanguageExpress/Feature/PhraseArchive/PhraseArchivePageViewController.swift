//
//  PhraseArchivePageViewController.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/26/24.
//

import UIKit
import Then
import SnapKit

final class PhraseArchivePageViewController: BaseViewController, PageComponentProtocol {
    var pageTitle: String = ""
    var label: UILabel!
    
    convenience init(type: String) {
        self.init()
        self.pageTitle = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        label = UILabel().then {
            view.addSubview($0)
            $0.text = pageTitle
            
            $0.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
}
