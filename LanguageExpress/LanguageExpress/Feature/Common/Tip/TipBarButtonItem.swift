//
//  TipBarButtonItem.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/23/24.
//

import UIKit

final class TipBarButtonItem: UIBarButtonItem {
    private var baseViewController: UIViewController?
    
    private lazy var button = {
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        config.preferredSymbolConfigurationForImage = imageConfig
        let action = UIAction(image: .bulb) { _ in
            self.createTipBuilder()
        }
        let view = UIButton(configuration: config, primaryAction: action)
        // TODO: 왜 addTarget으로 액션을 연결하면 "unrecognized selector sent to instance" 에러가 발생하는지 파악하기
//        view.addTarget(baseViewController, action: #selector(createTipBuilder), for: .touchUpInside)
        return view
    }()
    
    override private init() {
        super.init()
    }
    
    convenience init(baseViewController: UIViewController) {
        self.init()
        self.baseViewController = baseViewController
        customView = button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTipBuilder() {
        guard let baseViewController else { return }
        TipViewBuilder(viewController: baseViewController)
            .setImage(.tipDelete)
            .setTitle("모음집/구문 삭제하기")
            .setMessage("지우고 싶은 모음집 또는 구문을 꾹 누르면 삭제할 수 있는 창이 떠요!")
            .show()
    }
}
