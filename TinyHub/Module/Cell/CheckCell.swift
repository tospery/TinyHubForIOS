//
//  CheckCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/29.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class CheckCell: BaseCollectionCell, ReactorKit.View {
    
    lazy var label: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .normal(15)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var imageView: UIImageView = {
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
        self.contentView.addSubview(self.imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.sizeToFit()
        self.label.left = 15
        self.label.top = self.label.topWhenCenter
        self.imageView.right = self.contentView.width - 15
        self.imageView.top = self.imageView.topWhenCenter
    }

    func bind(reactor: CheckItem) {
        super.bind(item: reactor)
        if let parent = reactor.parent as? ListViewReactor {
            var convertible: CustomStringConvertible?
            if let element = (self.model as? BaseModel)?.data as? SectionItemElement {
                if case let .check(name) = element {
                    convertible = name
                }
            }
            parent.state.map {
                ($0.data as? CustomStringConvertible)?.description == convertible?.description
            }
                .distinctUntilChanged()
                .map(Reactor.Action.select)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        }
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.label.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { !($0.selected ?? false) }
            .distinctUntilChanged()
            .bind(to: self.imageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 46)
    }

}
