//
//  RepoListViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/3.
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
import HiIOS

class RepoListViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
        self.shouldRefresh = reactor.parameters.bool(for: Parameter.shouldRefresh) ?? true
        self.shouldLoadMore = reactor.parameters.bool(for: Parameter.shouldLoadMore) ?? (
            (reactor as? ListViewReactor)?.page == .trendingRepos ? false : true
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: GeneralViewReactor) {
        super.bind(reactor: reactor)
        let page = (self.reactor as? ListViewReactor)?.page
        if page == .trendingRepos {
            reactor.state.map { ($0.configuration as? Configuration)?.trendingSince }
                .distinctUntilChanged()
                .skip(1)
                .subscribeNext(weak: self, type(of: self).handleTrendingSince)
                .disposed(by: self.rx.disposeBag)
            reactor.state.map { ($0.configuration as? Configuration)?.trendingLanguage }
                .distinctUntilChanged()
                .skip(1)
                .subscribeNext(weak: self, type(of: self).handleTrendingLanguage)
                .disposed(by: self.rx.disposeBag)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.pagingViewController != nil &&
            !self.scrollView.bounds.equalTo(self.view.bounds) {
            self.scrollView.frame = self.view.bounds
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var size = super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        if size.width > deviceWidth {
            size.width = deviceWidth
        }
        return size
    }
    
    override func handleContents(contents: [HiContent]) {
        guard let page = (self.reactor as? TinyHub.ListViewReactor)?.page, page == .trendingRepos else { return }
        guard let repos = contents.first?.models as? [Repo], repos.isNotEmpty else { return }
        Repo.storeArray(repos, page: page.rawValue)
        log("repo缓存->\(page.rawValue)")
    }

    func handleTrendingSince(since: Since?) {
        MainScheduler.asyncInstance.scheduleRelative((), dueTime: .milliseconds(200)) { [weak self] _ -> Disposable in
            guard let `self` = self else { fatalError() }
            self.reactor?.action.onNext(.reload)
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
    func handleTrendingLanguage(language: Language?) {
        MainScheduler.asyncInstance.scheduleRelative((), dueTime: .milliseconds(200)) { [weak self] _ -> Disposable in
            guard let `self` = self else { fatalError() }
            self.reactor?.action.onNext(.reload)
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
}
