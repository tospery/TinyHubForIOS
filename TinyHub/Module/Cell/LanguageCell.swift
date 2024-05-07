//
//  LanguageCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/11.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class LanguageCell: BaseCollectionCell, ReactorKit.View {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .normal(15)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .random
        imageView.sizeToFit()
        imageView.size = .init(12)
        imageView.layerCornerRadius = imageView.height / 2.f
        return imageView
    }()
    
    lazy var checkedImageView: UIImageView = {
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
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.colorImageView)
        self.contentView.addSubview(self.checkedImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorImageView.left = 15
        self.colorImageView.top = self.colorImageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.colorImageView.right + 10
        self.nameLabel.top = self.nameLabel.topWhenCenter
        self.checkedImageView.right = self.contentView.width - 15
        self.checkedImageView.top = self.checkedImageView.topWhenCenter
    }

    func bind(reactor: LanguageItem) {
        super.bind(item: reactor)
        if let parent = reactor.parent as? ListViewReactor {
            let language = self.model as? Language
            parent.state.map { ($0.data as? OptionsViewReactor.Data)?.language == language }
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
        .init(width: width, height: 46)
    }

}
