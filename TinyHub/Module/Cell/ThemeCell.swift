//
//  ThemeCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/30.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class ThemeCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 50.f
    }
    
    lazy var label: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .normal(15)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.size = .init(Metric.height * 0.78)
        imageView.layerCornerRadius = imageView.height / 2.0
        return imageView
    }()
    
    lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = R.image.ic_checked()?.template
        imageView.theme.tintColor = themeService.attribute { $0.primaryColor }
        imageView.sizeToFit()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.checkImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImageView.left = 15
        self.iconImageView.top = self.iconImageView.topWhenCenter
        self.label.sizeToFit()
        self.label.left = self.iconImageView.right + 10
        self.label.top = self.label.topWhenCenter
        self.checkImageView.right = self.contentView.width - 15
        self.checkImageView.top = self.checkImageView.topWhenCenter
    }

    func bind(reactor: ThemeItem) {
        super.bind(item: reactor)
        if let parent = reactor.parent as? ListViewReactor {
            var colorTheme: ColorTheme?
            if let element = (self.model as? BaseModel)?.data as? SectionItemElement {
                if case let .theme(theme) = element {
                    colorTheme = theme
                }
            }
            parent.state.map {
                ($0.data as? ColorTheme)?.description == colorTheme?.description
            }
                .distinctUntilChanged()
                .map(Reactor.Action.select)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        }
        reactor.state.map { $0.colorTheme?.description }
            .distinctUntilChanged()
            .bind(to: self.label.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.colorTheme?.primaryColor }
            .distinctUntilChanged()
            .bind(to: self.iconImageView.rx.backgroundColor)
            .disposed(by: self.disposeBag)
        reactor.state.map { !($0.selected ?? false) }
            .distinctUntilChanged()
            .bind(to: self.checkImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: Metric.height)
    }

}
