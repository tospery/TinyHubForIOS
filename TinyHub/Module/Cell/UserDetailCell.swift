//
//  UserDetailCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/31.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class UserDetailCell: BaseCollectionCell, ReactorKit.View {

    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 2
        label.font = .bold(16)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var joinLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(12)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = TinyHub.Metric.DetailCell.maxLines
        label.font = .normal(14)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 6
        imageView.sizeToFit()
        imageView.size = TinyHub.Metric.DetailCell.avatarSize
        return imageView
    }()
    
    lazy var infoView: UIView = {
        let view = UIView.init()
        view.sizeToFit()
        return view
    }()
    
    lazy var statView: StatView = {
        let view = StatView.init()
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.statView)
        self.contentView.addSubview(self.infoView)
        self.infoView.addSubview(self.avatarImageView)
        self.infoView.addSubview(self.nameLabel)
        self.infoView.addSubview(self.locationLabel)
        self.infoView.addSubview(self.joinLabel)
        self.infoView.addSubview(self.descLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.statView.left = 0
        self.statView.bottom = self.contentView.height
        self.avatarImageView.left = TinyHub.Metric.DetailCell.margin.left
        self.avatarImageView.top = TinyHub.Metric.DetailCell.margin.top
        self.joinLabel.sizeToFit()
        self.joinLabel.left = self.avatarImageView.right + TinyHub.Metric.DetailCell.padding.horizontal
        self.joinLabel.bottom = self.avatarImageView.bottom
        self.locationLabel.sizeToFit()
        self.locationLabel.left = self.joinLabel.left
        self.locationLabel.bottom = self.joinLabel.top - 2
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.joinLabel.left
        self.nameLabel.top = 4
        self.nameLabel.extendToRight = self.contentView.width - TinyHub.Metric.DetailCell.margin.right
        self.nameLabel.extendToBottom = self.locationLabel.top
        self.descLabel.sizeToFit()
        self.descLabel.width = self.contentView.width - TinyHub.Metric.DetailCell.margin.horizontal
        self.descLabel.left = self.avatarImageView.left
        self.descLabel.top = self.avatarImageView.bottom
        self.descLabel.extendToBottom = self.statView.top
    }

    func bind(reactor: UserDetailItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.location }
            .distinctUntilChanged()
            .bind(to: self.locationLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.join }
            .distinctUntilChanged()
            .bind(to: self.joinLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.desc }
            .distinctUntilChanged()
            .bind(to: self.descLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.avatar }
            .distinctUntilChanged { HiIOS.compareImage($0, $1) }
            .bind(to: self.avatarImageView.rx.imageResource(placeholder: R.image.ic_user_default()))
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .bind(to: self.statView.rx.user)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let item = item as? UserDetailItem else { return .zero }
        var height = StatView.Metric.height
        height += UILabel.size(
            attributedString: item.currentState.desc?
                .styled(with: .font(.normal(14))),
            withConstraints: .init(
                width: width - TinyHub.Metric.DetailCell.margin.horizontal,
                height: .greatestFiniteMagnitude
            ),
            limitedToNumberOfLines: UInt(TinyHub.Metric.DetailCell.maxLines)
        ).height
        height += TinyHub.Metric.DetailCell.margin.vertical
        height += TinyHub.Metric.DetailCell.avatarSize.height
        height += 15
        return .init(width: width, height: height)
    }

}
