//
//  MilestoneCell.swift
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
import SwiftSVG
import HiIOS

class MilestoneCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let size = CGSize.init(width: 700.f, height: 120.f)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.theme.backgroundColor = themeService.attribute { $0.lightColor }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let svgView = self.contentView.viewWithTag(100) as? UIScrollView
        svgView?.width = self.contentView.width + 40
        svgView?.height = self.contentView.height
        svgView?.left = -15
        svgView?.top = 0
    }

    func bind(reactor: MilestoneItem) {
        super.bind(item: reactor)
        if let parent = reactor.parent as? ListViewReactor {
            parent.state.map { ($0.user as? User)?.milestone }
                .distinctUntilChanged()
                .map(Reactor.Action.url)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        }
        reactor.state.map { $0.url }
            .distinctUntilChanged()
            .bind(to: self.rx.url)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: Metric.size.height)
    }

}

extension Reactive where Base: MilestoneCell {

    var url: Binder<String?> {
        return Binder(self.base) { cell, url in
            guard let url = url?.url else { return }
            if let old = cell.contentView.viewWithTag(100) {
                old.removeFromSuperview()
            }
            let new = UIScrollView.init(SVGURL: url)
            new.tag = 100
            new.contentSize = MilestoneCell.Metric.size
            new.showsHorizontalScrollIndicator = false
            new.showsVerticalScrollIndicator = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                new.scrollToRight(animated: true)
            }
            cell.contentView.addSubview(new)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }

}
