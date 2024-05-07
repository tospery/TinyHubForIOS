//
//  BranchCell.swift
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
import HiIOS

class BranchCell: BaseCollectionCell, ReactorKit.View {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(15)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.ic_branch()
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var checkedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.ic_checked()?.template
        imageView.theme.tintColor = themeService.attribute { $0.primaryColor }
        imageView.sizeToFit()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.checkedImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImageView.left = 10
        self.iconImageView.top = self.iconImageView.topWhenCenter
        self.checkedImageView.right = self.contentView.width - 15
        self.checkedImageView.top = self.checkedImageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.iconImageView.right + 5
        self.nameLabel.width = self.checkedImageView.left - self.nameLabel.left
        self.nameLabel.top = self.nameLabel.topWhenCenter
    }

    func bind(reactor: BranchItem) {
        super.bind(item: reactor)
        if let parent = reactor.parent as? BranchListViewReactor {
            let name = (self.model as? Branch)?.id
            parent.state.map {
                ($0.data as? BranchListViewReactor.Data)?.selected == name
            }
                .distinctUntilChanged()
                .map(Reactor.Action.select)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        }
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { !($0.selected ?? false) }
            .distinctUntilChanged()
            .bind(to: self.checkedImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 44)
    }

}
