//
//  UserPlainCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/10.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class UserPlainCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 60.f
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.font = .bold(16)
        label.theme.textColor = themeService.attribute { $0.primaryColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(14)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 6
        imageView.sizeToFit()
        imageView.size = .init((Metric.height * 0.72).flat)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.contentView.addSubview(self.avatarImageView)
        // self.contentView.addSubview(self.followButton)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.urlLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImageView.left = 15
        self.avatarImageView.top = self.avatarImageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.avatarImageView.right + 10
        self.nameLabel.width = self.contentView.width - self.nameLabel.left - 20
        self.nameLabel.bottom = self.avatarImageView.centerY - 1
        self.urlLabel.sizeToFit()
        self.urlLabel.width = self.nameLabel.width
        self.urlLabel.left = self.nameLabel.left
        self.urlLabel.top = self.nameLabel.bottom + 2
    }

    func bind(reactor: UserPlainItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.url }
            .distinctUntilChanged()
            .bind(to: self.urlLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.avatar }
            .distinctUntilChanged { HiIOS.compareImage($0, $1) }
            .bind(to: self.avatarImageView.rx.imageResource(placeholder: R.image.ic_user_default()))
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: Metric.height)
    }

}
