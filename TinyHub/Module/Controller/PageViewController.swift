//
//  PageViewController.swift
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
import ReusableKit_Hi
import ObjectMapper_Hi
import RxDataSources
import RxGesture
import MXParallaxHeader
import SnapKit
import Parchment
import HiIOS

class PageViewController: ScrollViewController, ReactorKit.View {
    
    lazy var paging: PagingViewController = {
        let paging = PagingViewController.init()
        paging.textColor = .foreground
        paging.selectedTextColor = .primary
        paging.menuBackgroundColor = .background
        paging.menuHorizontalAlignment = .center
        paging.borderOptions = .visible(
            height: pixelOne,
            zIndex: .max - 1,
            insets: .zero
        )
        paging.borderColor = .border
        paging.menuItemLabelSpacing = 12
        paging.indicatorOptions = .visible(
            height: 3,
            zIndex: .max,
            spacing: .zero,
            insets: .zero
        )
        paging.indicatorColor = .primary
        paging.menuItemSize = .selfSizing(estimatedWidth: 50, height: TinyHub.Metric.menuHeight)
        return paging
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        defer {
            self.reactor = reactor as? PageViewReactor
        }
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(self.paging)
        self.view.addSubview(self.paging.view)
        self.paging.view.frame = self.scrollView.frame
        self.paging.didMove(toParent: self)
        self.paging.dataSource = self.reactor
        if let index = self.reactor?.parameters.int(for: Parameter.index), index != 0 {
            self.paging.select(index: index)
        }
    }
    
    func bind(reactor: PageViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.load.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading)
            .disposed(by: self.disposeBag)
    }

    func tapSearch(_: Void? = nil) {
        self.navigator.presentX(
            Router.shared.urlString(host: .search, path: .history),
            wrap: NavigationController.self,
            animated: false
        )
    }
    
}
