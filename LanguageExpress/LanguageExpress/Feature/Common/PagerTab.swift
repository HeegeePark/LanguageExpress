//
//  PagerTab.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/26/24.
//

import UIKit
import SnapKit
import Then

protocol PageComponentProtocol where Self: UIViewController {
    var pageTitle: String { get set }
}

class PagerTab: UIView {
    private var style = Style.default

    private var pageContents: [PageContent] = []
    private var currentIndex = 0 {
        didSet {
            pageContents.enumerated().forEach { index, content in
                
                content.button.then {
                    $0.isSelected = index == currentIndex
                    
                    if $0.isSelected {
                        $0.titleLabel?.font = style.titleActiveFont
                        $0.backgroundColor? = style.buttonBackgroundActiveColor
                        $0.setShadow(color: style.buttonShadowColor, opacity: style.buttonShadowOpacity)
                    } else {
                        $0.titleLabel?.font = style.titleActiveFont
                        $0.backgroundColor? = style.buttonBackgroundDefaultColor
                        $0.removeShadow()
                    }
                }
            }
        }
    }
    
    private let horizontalScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let tabStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.backgroundColor = .clear
    }

    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.backgroundColor = .clear
    }

    private lazy var barBackgroundView = UIView().then {
        let lineView = UIView()
        lineView.backgroundColor = .clear
        $0.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    private lazy var barView: UIView = {
        let view = UIView()
        let colorView = UIView()
        colorView.backgroundColor = .clear
        colorView.layer.cornerRadius = style.barCornerRadius
        view.addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(style.barHorizontalSpacing / 2)
        }
        return view
    }()

    private let containerView: UIView = UIView()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    private var selectedButton = false

    // MARK: PagerTab을 쓰기 위한 필수 부분. 반드시 setup을 호출해야함.
    func setup(_ target: UIViewController, viewControllers: [PageComponentProtocol], style: Style = .default) {
        self.style = style
        configureUI()

        target.addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: target)
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        pageContents = viewControllers.map {
            let button = setButton(width: buttonWidth(text: $0.pageTitle))
            button.setTitle($0.pageTitle, for: .normal)
            return PageContent(button: button, viewController: $0)
        }
        setupPageViewController()
        updatePagerTabButton()
    }

    private func configureUI() {
        addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(tabStackView)
        let leadingSpacingView = UIView()
        tabStackView.addArrangedSubview(leadingSpacingView)
        tabStackView.addArrangedSubview(titleStackView)
        addSubview(barBackgroundView)
        barBackgroundView.addSubview(barView)
        addSubview(containerView)
        
        horizontalScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.center.width.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        tabStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
            $0.edges.equalToSuperview()
        }
        
        leadingSpacingView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(10)
        }
        
        titleStackView.snp.makeConstraints {
            $0.leading.equalTo(leadingSpacingView.snp.trailing)
            $0.top.trailing.bottom.equalToSuperview()
        }
        
        tabStackView.setCustomSpacing(0, after: tabStackView.subviews[1])
        
        barBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(style.barHeight)
        }
        
        barView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(barBackgroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setButton(width: CGFloat) -> UIButton {
        return UIButton().then {
            $0.titleLabel?.font = style.titleDefaultFont
            $0.setTitleColor(style.titleDefaultColor, for: .normal)
            $0.setTitleColor(style.titleActiveColor, for: .selected)
            $0.layer.cornerRadius = 16
            $0.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
            $0.titleLabel?.sizeToFit()
            
            $0.snp.makeConstraints() {
                let inset: CGFloat = 16
                $0.width.equalTo(inset * 2 + width)
            }
        }
    }
    
    private func buttonWidth(text: String) -> CGFloat {
        let label = UILabel().then {
            $0.font = style.titleDefaultFont
            $0.text = text
            $0.sizeToFit()
        }
        
        return label.frame.width
    }

    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self

        if let viewController = pageContents.first?.viewController {
            pageViewController.setViewControllers(
                [viewController],
                direction: .forward,
                animated: false,
                completion: nil)
            currentIndex = 0
        }

        for subview in pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }

    private func updatePagerTabButton() {
        let barCount = pageContents.count
        pageContents.enumerated().forEach { index, content in
            content.button.backgroundColor = index == currentIndex ? style.buttonBackgroundActiveColor: style.buttonBackgroundDefaultColor
            titleStackView.addArrangedSubview(content.button)
        }
        barView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(max(barCount, 1))
        }
    }

    @objc private func selectButton(_ sender: UIButton) {
        guard let index = pageContents.firstIndex(where: { $0.button === sender }),
              index != currentIndex
        else {
            return
        }

        selectedButton = true
        pageViewController.view.isUserInteractionEnabled = false

        barView.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(CGFloat(index) * barView.frame.width)
        }
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut) {
            self.barBackgroundView.layoutIfNeeded()
        } completion: { _ in
            self.selectedButton = false
            self.pageViewController.view.isUserInteractionEnabled = true
        }

        let content = pageContents[index]
        pageViewController.setViewControllers(
            [content.viewController],
            direction: currentIndex < index ? .forward : .reverse,
            animated: true) { [weak self] _ in
            self?.currentIndex = index
        }
    }
}

extension PagerTab: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageContents.firstIndex(where: { $0.viewController === viewController }) else {
            return nil
        }
        let afterIndex = index + 1
        if afterIndex < pageContents.count {
            return pageContents[afterIndex].viewController
        }
        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageContents.firstIndex(where: { $0.viewController === viewController }) else {
            return nil
        }
        let beforeIndex = index - 1
        if beforeIndex >= 0 {
            return pageContents[beforeIndex].viewController
        }
        return nil
    }
}

extension PagerTab: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = pageContents.firstIndex(where: { $0.viewController === viewController }) else {
            return
        }
        currentIndex = index
    }
}

extension PagerTab: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !selectedButton else { return }
        let offsetX = scrollView.contentOffset.x
        let percentComplete = (offsetX - pageViewController.view.frame.width) / pageViewController.view.frame.width
        barView.snp.updateConstraints {
            $0.leading.equalToSuperview().inset((percentComplete + CGFloat(currentIndex)) * barView.frame.width)
        }
    }
}

extension PagerTab {
    struct Style {
        var barColor: UIColor
        var barHeight: CGFloat
        var barHorizontalSpacing: CGFloat
        var barCornerRadius: CGFloat
        var barDividerColor: UIColor

        var buttonBackgroundActiveColor: UIColor
        var buttonBackgroundDefaultColor: UIColor
        var buttonHeight: CGFloat
        
        var buttonShadowOpacity: Float
        var buttonShadowColor: UIColor
        var buttonShadowOffset: CGSize

        var titleActiveColor: UIColor
        var titleDefaultColor: UIColor
        var titleActiveFont: UIFont
        var titleDefaultFont: UIFont

        static var `default` = Style(
            barColor: .orange,
            barHeight: 3.0,
            barHorizontalSpacing: 10.0,
            barCornerRadius: 2.0,
            barDividerColor: .red,
            buttonBackgroundActiveColor: .primary,
            buttonBackgroundDefaultColor: .clear,
            buttonHeight: 32.0,
            buttonShadowOpacity: 0.2,
            buttonShadowColor: .primary,
            buttonShadowOffset: CGSize(width: 5, height: 5),
            titleActiveColor: .white,
            titleDefaultColor: .deactiveGray,
            titleActiveFont: .sfPro15Regular,
            titleDefaultFont: .sfPro15Regular
        )
    }

    struct PageContent {
        let button: UIButton
        let viewController: PageComponentProtocol
    }
}
