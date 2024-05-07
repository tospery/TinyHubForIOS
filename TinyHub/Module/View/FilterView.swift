//
//  FilterView.swift
//  TinyHub
//
//  Created by 杨建祥 on 2024/3/21.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import HiIOS

class FilterView: BaseView {
    
    struct Metric {
        static let height = 40.f
        static let itemWidth = ((deviceWidth - 3 * spaceWidth) / 2.0).flat
        static let buttonHeight = 28.f
        static let spaceWidth = (deviceWidth * 0.1).flat
    }
    
    lazy var sinceButton: UIButton = {
        let button = UIButton.init(type: .custom)
        let title = "\(Configuration.current?.trendingSince.title ?? "") ▼"
        button.setTitle(title, for: .normal)
        button.layerCornerRadius = Metric.buttonHeight / 2.0
        button.titleLabel?.font = .normal(15)
        button.theme.titleColor(
            from: themeService.attribute { $0.backgroundColor },
            for: .normal
        )
        button.theme.backgroundColor = themeService.attribute { $0.primaryColor }
        button.sizeToFit()
        return button
    }()
    
    lazy var languageButton: UIButton = {
        let button = UIButton.init(type: .custom)
        let title = "\(Configuration.current?.trendingLanguage?.name ?? "") ▼"
        button.setTitle(title, for: .normal)
        button.layerCornerRadius = Metric.buttonHeight / 2.0
        button.titleLabel?.font = self.langFont(title)
        button.theme.titleColor(
            from: themeService.attribute { $0.backgroundColor },
            for: .normal
        )
        button.theme.backgroundColor = themeService.attribute { $0.primaryColor }
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.qmui_borderWidth = pixelOne
        self.qmui_borderPosition = .bottom
        self.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.addSubview(self.sinceButton)
        self.addSubview(self.languageButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sinceButton.sizeToFit()
        self.sinceButton.width = Metric.itemWidth
        self.sinceButton.height = Metric.buttonHeight
        self.sinceButton.top = self.sinceButton.topWhenCenter
        self.sinceButton.left = Metric.spaceWidth
        self.languageButton.sizeToFit()
        self.languageButton.width = self.sinceButton.width
        self.languageButton.height = Metric.buttonHeight
        self.languageButton.top = self.languageButton.topWhenCenter
        self.languageButton.right = self.width - Metric.spaceWidth
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: deviceWidth, height: Metric.height)
    }
    
    func langFont(_ title: String) -> UIFont {
        let width = UILabel.size(
            attributedString: title.styled(with: .font(.normal(15))),
            withConstraints: .init(
                width: CGFloat.greatestFiniteMagnitude,
                height: 40
            ),
            limitedToNumberOfLines: 1
        ).width
        let ratio = width / Metric.itemWidth
        log("语言长度占的比例: \(ratio)")
        if ratio < 0.9 {
            return .normal(15)
        } else if ratio >= 0.9 && ratio < 1.2 {
            return .normal(12)
        }
        return .normal(9)
    }
    
    func reload() {
        MainScheduler.asyncInstance.scheduleRelative((), dueTime: .milliseconds(200)) { [weak self] _ in
            guard let `self` = self else { fatalError() }
            let title = "\(Configuration.current?.trendingSince.title ?? "") ▼"
            self.sinceButton.setTitle(title, for: .normal)
            self.setNeedsLayout()
            self.layoutIfNeeded()
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
}

extension Reactive where Base: FilterView {

    var since: Binder<Since> {
        return Binder(self.base) { view, since in
            let title = since.title + " ▼"
            log("筛选栏显示的since: \(title)")
            view.sinceButton.setTitle(title, for: .normal)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    var language: Binder<Language?> {
        return Binder(self.base) { view, language in
            let title = (language?.name ?? R.string.localizable.anyLanguage(preferredLanguages: myLangs)) + " ▼"
            view.languageButton.titleLabel?.font = view.langFont(title)
            view.languageButton.setTitle(title, for: .normal)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    var tapSince: ControlEvent<Void> {
        self.base.sinceButton.rx.tap
    }
    
    var tapLanguage: ControlEvent<Void> {
        self.base.languageButton.rx.tap
    }

}
