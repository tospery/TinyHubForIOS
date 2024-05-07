//
//  DirSingleCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/16.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class DirSingleCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 44.f
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(15)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.size = .init(32)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.iconImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let content = self.model as? Content else { return }
        self.iconImageView.left = ((content.tree.count + 1) * 15).f.flat
        self.iconImageView.top = self.iconImageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.iconImageView.right + 10
        self.nameLabel.top = self.nameLabel.topWhenCenter
    }

    func bind(reactor: DirSingleItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.icon }
            .distinctUntilChanged { HiIOS.compareImage($0, $1) }
            .bind(to: self.iconImageView.rx.imageResource(placeholder: R.image.ic_user_default()))
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: Metric.height)
    }

}
