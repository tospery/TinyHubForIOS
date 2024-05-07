//
//  TrendingViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
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
import Parchment
import SnapKit
import AMPopTip
import HiIOS

class TrendingViewController: ScrollViewController, ReactorKit.View {
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl.init()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.transform = CGAffineTransformMakeScale(0.6, 0.6)
        pageControl.theme.pageIndicatorTintColor = themeService.attribute { $0.footerColor }
        pageControl.theme.currentPageIndicatorTintColor = themeService.attribute { $0.primaryColor }
        return pageControl
    }()
    
    lazy var filterView: FilterView = {
        let view = FilterView.init()
        view.sizeToFit()
        view.rx.tapSince
            .subscribeNext(weak: self, type(of: self).tapSince)
            .disposed(by: self.rx.disposeBag)
        view.rx.tapLanguage
            .subscribeNext(weak: self, type(of: self).tapLanguage)
            .disposed(by: self.rx.disposeBag)
        return view
    }()
    
    lazy var paging: NavigationBarPagingViewController = {
        let paging = NavigationBarPagingViewController()
        paging.indicatorOptions = .hidden
        // paging.menuTransition = .animateAfter
        paging.selectedScrollPosition = .center
        paging.menuBackgroundColor = .clear
        paging.menuHorizontalAlignment = .center
        paging.borderOptions = .hidden
        // paging.menuItemLabelSpacing = 0
        paging.font = .bold(16)
        paging.selectedFont = paging.font
        paging.menuInteraction = .none
        // paging.menuItemSize = .selfSizing(estimatedWidth: 100, height: navigationBarHeight)
        paging.menuItemSize = .sizeToFit(minWidth: 10, height: navigationBarHeight)
        paging.textColor = .clear
        // paging.theme.textColor = themeService.attribute { $0.footerColor }
        paging.theme.selectedTextColor = themeService.attribute { $0.primaryColor }
        paging.theme.indicatorColor = themeService.attribute { $0.primaryColor }
        return paging
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        defer {
            self.reactor = reactor as? TrendingViewReactor
        }
        super.init(navigator, reactor)
        self.hidesNavBottomLine = reactor.parameters.bool(for: Parameter.hidesNavBottomLine) ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.addChild(self.paging)
        self.view.addSubview(self.paging.view)
        self.paging.view.frame = self.scrollView.frame
        self.paging.view.height -= self.filterView.height
        self.paging.view.top += self.filterView.height
        self.paging.didMove(toParent: self)
        self.paging.dataSource = self.reactor
        self.paging.delegate = self

        self.paging.collectionView.size = CGSize(width: self.view.width, height: navigationBarHeight)
        self.navigationBar.titleView = self.paging.collectionView

        self.view.addSubview(self.filterView)
        // v1.0.0版本屏蔽该功能，完善功能后下个版本打开
//        self.navigationBar.addButtonToLeft(image: R.image.nav_menu()).rx.tap
//            .subscribeNext(weak: self, type(of: self).tapMenu)
//            .disposed(by: self.disposeBag)
        self.navigationBar.addButtonToRight(image: R.image.navbar_search()).rx.tap
            .subscribeNext(weak: self, type(of: self).tapSearch)
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.pageControl.left = self.pageControl.leftWhenCenter
//        self.pageControl.bottom = self.navigationBar.height
        self.filterView.left = self.filterView.leftWhenCenter
        self.filterView.top = self.navigationBar.bottom
    }
    
    func bind(reactor: TrendingViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.load.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.configuration }
            .distinctUntilChanged()
            .skip(1)
            .subscribeNext(weak: self, type(of: self).handleConfiguration)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.configuration.trendingSince }
            .distinctUntilChanged()
            .bind(to: self.filterView.rx.since)
            .disposed(by: self.rx.disposeBag)
        reactor.state.map { $0.configuration.trendingLanguage }
            .distinctUntilChanged()
            .bind(to: self.filterView.rx.language)
            .disposed(by: self.rx.disposeBag)
        // state
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
    
    func tapSince(_: Void? = nil) {
        guard var configuration = self.reactor?.currentState.configuration as? Configuration else { return }
        let frame = CGRect.init(
            x: self.filterView.sinceButton.left,
            y: self.filterView.sinceButton.top + self.navigationBar.bottom,
            width: self.filterView.sinceButton.width,
            height: self.filterView.sinceButton.height
        )
        let selected = Since.allValues.firstIndex(of: configuration.trendingSince)?.uInt ?? 0
        self.navigator.rxPopup(.sinces, context: [
            Parameter.selected: Int(selected),
            Parameter.frame: String.init(describing: frame)
        ]).subscribe(onNext: { result in
            configuration.trendingSince = result as? Since ?? .daily
            Subjection.update(Configuration.self, configuration, true)
        }).disposed(by: self.disposeBag)
    }
    
    func tapLanguage(_: Void? = nil) {
        self.navigator.presentX(
            Router.shared.urlString(host: .trending, path: .languages), wrap: NavigationController.self
        )
    }
    
    func handleConfiguration(configuration: Configuration) {
        log("handleConfiguration -> 更新配置(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? ""))")
        self.paging.reloadMenu()
        self.filterView.reload()
        MainScheduler.asyncInstance.schedule(()) { _ -> Disposable in
            Subjection.update(Configuration.self, configuration, true)
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
    override func handleTheme(_ themeType: ThemeType) {
        log("trending-theme-changed")
        self.paging.reloadMenu()
    }
    
}

extension TrendingViewController: PagingViewControllerDelegate {
    
    func pagingViewController(
        _ pagingViewController: PagingViewController,
        didScrollToItem pagingItem: PagingItem,
        startingViewController: UIViewController?,
        destinationViewController: UIViewController,
        transitionSuccessful: Bool
    ) {
        guard let pagingIndexItem = pagingItem as? PagingIndexItem else { return }
        self.pageControl.currentPage = pagingIndexItem.index
    }
    
}
