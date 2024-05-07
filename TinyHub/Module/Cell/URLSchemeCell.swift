//
//  URLSchemeCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/27.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class URLSchemeCell: BaseCollectionCell, ReactorKit.View {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(16)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(13)
        label.theme.textColor = themeService.attribute { $0.bodyColor }
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 15)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.urlLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.sizeToFit()
        self.nameLabel.left = 15
        self.nameLabel.bottom = self.contentView.height / 2.0
        self.urlLabel.sizeToFit()
        self.urlLabel.left = self.nameLabel.left
        self.urlLabel.top = self.contentView.height / 2.0 + 4
    }

    func bind(reactor: URLSchemeItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.url }
            .distinctUntilChanged()
            .bind(to: self.urlLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 50)
    }

}
