//
//  StateCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/18.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import TagListView
import HiIOS

class StateCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 33.f
        static let tagHeight = 24.f
        static let commentWidth = 40.f
        static let margin = UIEdgeInsets.init(top: 5, left: 15, bottom: 8, right: 5)
        static let padding = UIOffset.init(horizontal: 10, vertical: 5)
        static let avatarSize = CGSize.init(20)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(14)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(11)
        label.theme.textColor = themeService.attribute { $0.bodyColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        label.width = Metric.commentWidth
        label.height = UIFont.normal(14).lineHeight.flat
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 4
        imageView.sizeToFit()
        imageView.size = Metric.avatarSize
        return imageView
    }()
    
    lazy var tagView: TagListView = {
        let view = TagListView.init(frame: .zero)
        view.paddingX = 8
        view.paddingY = 4
        view.marginX = 10
        view.marginY = 2
        view.textFont = .normal(11)
        view.textColor = .background
        view.tagBackgroundColor = .light
        view.cornerRadius = (view.paddingY + view.marginY + view.textFont.lineHeight) / 2.f
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.commentLabel)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.tagView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImageView.left = Metric.margin.left
        self.avatarImageView.bottom = self.contentView.bottom - Metric.margin.bottom
        self.commentLabel.right = self.contentView.width
        self.commentLabel.centerY = self.avatarImageView.centerY
        self.timeLabel.sizeToFit()
        self.timeLabel.right = self.commentLabel.left - Metric.padding.horizontal
        self.timeLabel.centerY = self.avatarImageView.centerY
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.avatarImageView.right + Metric.padding.horizontal
        self.nameLabel.centerY = self.avatarImageView.centerY
        self.nameLabel.extendToRight = self.timeLabel.left - Metric.padding.horizontal / 2.0
        self.tagView.left = self.avatarImageView.left
        self.tagView.width = self.width - self.tagView.left - Metric.margin.right
        if (self.model as? Pull)?.labels.count ?? 0 != 0 ||
            (self.model as? Issue)?.labels.count ?? 0 != 0 {
            self.tagView.height = Metric.tagHeight
        } else {
            self.tagView.height = 0
        }
        self.tagView.bottom = self.avatarImageView.top
        self.titleLabel.sizeToFit()
        self.titleLabel.width = self.tagView.width
        self.titleLabel.left = self.avatarImageView.left
        self.titleLabel.top = Metric.margin.top
        self.titleLabel.extendToBottom = self.tagView.top
    }

    func bind(reactor: StateItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.titleLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.time }
            .distinctUntilChanged()
            .bind(to: self.timeLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.comment }
            .distinctUntilChanged()
            .bind(to: self.commentLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.labels }
            .distinctUntilChanged()
            .bind(to: self.rx.labels)
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
        guard let item = item as? StateItem else { return .zero }
        var height = Metric.height
        height += UILabel.size(
            attributedString: item.currentState.title,
            withConstraints: .init(
                width: width - Metric.margin.horizontal,
                height: .greatestFiniteMagnitude
            ),
            limitedToNumberOfLines: 2
        ).height
        if item.currentState.labels?.count ?? 0 != 0 {
            height += Metric.tagHeight
        }
        height += 10
        return .init(width: width, height: height)
    }

}

extension Reactive where Base: StateCell {
    
    var labels: Binder<[Label]?> {
        return Binder(self.base) { cell, labels in
            cell.tagView.removeAllTags()
            for label in labels ?? [] {
                let view = cell.tagView.addTag(label.name ?? "")
                view.tagBackgroundColor = label.color?.color ?? .random
                view.textColor = view.tagBackgroundColor.qmui_colorIsDark ? .background : .foreground
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }
    
}
