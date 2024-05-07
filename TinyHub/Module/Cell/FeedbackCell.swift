//
//  FeedbackCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/6.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import TTTAttributedLabel
import BonMot
import HiIOS

class FeedbackCell: BaseCollectionCell, ReactorKit.View {
    
    lazy var label: TTTAttributedLabel = {
        let label = TTTAttributedLabel.init(frame: .zero)
        label.qmui_borderWidth = pixelOne
        label.qmui_borderPosition = .top
        label.font = .normal(13)
        label.textInsets = .init(horizontal: 10, vertical: 0)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        label.sizeToFit()
        label.height = 30
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView.init()
        textView.font = .normal(15)
        textView.placeholder = R.string.localizable.feedbackPlaceholder(
            preferredLanguages: myLangs
        )
        textView.theme.textColor = themeService.attribute { $0.titleColor }
        textView.theme.placeholderColor = themeService.attribute { $0.footerColor }
        textView.sizeToFit()
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.textView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.width = self.contentView.width
        self.label.left = 0
        self.label.bottom = self.contentView.height
        self.textView.width = self.contentView.width - 10
        self.textView.height = self.contentView.height - self.label.height - 10
        self.textView.left = 5
        self.textView.top = 5
    }

    func bind(reactor: FeedbackItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: metric(180))
    }

}

extension Reactive where Base: FeedbackCell {
    
    var title: Binder<String?> {
        return Binder(self.base) { cell, title in
            cell.label.setText(title)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }

    var body: ControlProperty<String?> {
        self.base.textView.rx.text
    }
    
}
