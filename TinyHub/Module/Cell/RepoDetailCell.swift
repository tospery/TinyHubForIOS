//
//  RepoDetailCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import TTTAttributedLabel
import HiIOS

class RepoDetailCell: BaseCollectionCell, ReactorKit.View {
    
    let clickSubject = PublishSubject<String>()
    
    lazy var nameLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel.init(frame: .zero)
        label.delegate = self
        label.verticalAlignment = .center
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    lazy var langLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var updateLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(11)
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
    
    lazy var statView: StatView = {
        let view = StatView.init()
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.statView)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.langLabel)
        self.contentView.addSubview(self.updateLabel)
        self.contentView.addSubview(self.descLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.statView.left = 0
        self.statView.bottom = self.contentView.height
        self.avatarImageView.left = TinyHub.Metric.DetailCell.margin.left
        self.avatarImageView.top = TinyHub.Metric.DetailCell.margin.top
        self.updateLabel.sizeToFit()
        self.updateLabel.left = self.avatarImageView.right + TinyHub.Metric.DetailCell.padding.horizontal
        self.updateLabel.bottom = self.avatarImageView.bottom
        self.langLabel.sizeToFit()
        self.langLabel.left = self.updateLabel.left
        self.langLabel.bottom = self.updateLabel.top - 2
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.updateLabel.left
        self.nameLabel.top = 4
        self.nameLabel.extendToRight = self.contentView.width - TinyHub.Metric.DetailCell.margin.right
        self.nameLabel.extendToBottom = self.langLabel.top
        self.descLabel.sizeToFit()
        self.descLabel.width = self.contentView.width - TinyHub.Metric.DetailCell.margin.horizontal
        self.descLabel.left = self.avatarImageView.left
        self.descLabel.top = self.avatarImageView.bottom
        self.descLabel.extendToBottom = self.statView.top
    }

    func bind(reactor: RepoDetailItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.repo }
            .distinctUntilChanged()
            .bind(to: self.statView.rx.repo)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.rx.name)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.lang }
            .distinctUntilChanged()
            .bind(to: self.langLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.update }
            .distinctUntilChanged()
            .bind(to: self.updateLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.desc }
            .distinctUntilChanged()
            .bind(to: self.descLabel.rx.text)
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
        guard let item = item as? RepoDetailItem else { return .zero }
        var height = StatView.Metric.height
        height += UILabel.size(
            attributedString: item.currentState.desc?.styled(with: .font(.normal(14))),
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

extension RepoDetailCell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith result: NSTextCheckingResult!) {
        guard result.range.location == 0 else { return }
        guard let username = (self.model as? Repo)?.owner.username else { return }
        self.clickSubject.onNext(username)
    }
}

extension Reactive where Base: RepoDetailCell {
    
    var clickUser: ControlEvent<String> {
        let source = self.base.clickSubject
        return ControlEvent(events: source)
    }
    
    var name: Binder<NSAttributedString?> {
        return Binder(self.base) { cell, name in
            cell.nameLabel.setText(name)
            if let string = name?.string {
                let array = string.components(separatedBy: " / ")
                if array.count == 2 {
                    let length = array.first?.count ?? 0
                    cell.nameLabel.addLink(.init(
                        attributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.primary,
                            NSAttributedString.Key.font: UIFont.bold(16)
                        ],
                        activeAttributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.red
                        ],
                        inactiveAttributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.gray
                        ],
                        textCheckingResult: .spellCheckingResult(range: .init(location: 0, length: length))
                    ))
                }
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }
    
}
