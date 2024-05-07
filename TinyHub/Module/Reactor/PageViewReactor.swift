//
//  PageViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/10.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import Parchment
import HiIOS

class PageViewReactor: ScrollViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setLoadingMore(Bool)
        case setTitle(String?)
        case setError(Error?)
        case setUser(User?)
        case setConfiguration(Configuration)
        case setPages([Page])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var isLoadingMore = false
        var noMoreData = false
        var error: Error?
        var title: String?
        var user: User?
        var configuration = Configuration.current!
        var pages = [Page].init()
    }

    let username: String
    let reponame: String
    var initialState = State()

    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        self.username = parameters?.string(for: Parameter.username) ?? ""
        self.reponame = parameters?.string(for: Parameter.reponame) ?? ""
        super.init(provider, parameters)
        let data = self.parameters.string(for: Parameter.pages)?.data(using: .utf8)
        let json = (try? data?.jsonObject()) as? [String] ?? []
        self.initialState = State(
            title: self.title ?? (self.reponame.isNotEmpty ? self.reponame : self.username),
            pages: json.map { Page.init(rawValue: $0) ?? .none }
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load: return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setRefreshing(isRefreshing):
            newState.isRefreshing = isRefreshing
        case let .setLoadingMore(isLoadingMore):
            newState.isLoadingMore = isLoadingMore
        case let .setTitle(title):
            newState.title = title
        case let .setError(error):
            newState.error = error
        case let .setUser(user):
            newState.user = user
        case let .setConfiguration(configuration):
            newState.configuration = configuration
        case let .setPages(pages):
            newState.pages = pages
        }
        return newState
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        action
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        .merge(
            mutation,
            Subjection.for(User.self)
                .distinctUntilChanged()
                .asObservable()
                .map(Mutation.setUser),
            Subjection.for(Configuration.self)
                .distinctUntilChanged()
                .filterNil()
                .asObservable()
                .map(Mutation.setConfiguration)
        )
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        state
    }
    
}

extension PageViewReactor: PagingViewControllerDataSource {
    
    func numberOfViewControllers(
        in pagingViewController: PagingViewController
    ) -> Int {
        self.currentState.pages.count
    }

    func pagingViewController(
        _ pagingViewController: PagingViewController,
        viewControllerAt index: Int
    ) -> UIViewController {
        let page = self.currentState.pages[index]
        let parameters = [
            Parameter.page: page.rawValue,
            Parameter.username: self.username,
            Parameter.reponame: self.reponame,
            Parameter.hidesNavigationBar: true.string
        ]
        switch page {
        case .repositories, .stars, .watchs, .forks:
            return self.navigator.viewController(
                for: Router.shared.urlString(host: .repo, path: .list, parameters: parameters)
            )!
        case .followers, .following, .watchers, .stargazers, .contributors:
            return self.navigator.viewController(
                for: Router.shared.urlString(host: .user, path: .list, parameters: parameters)
            )!
        case .open, .closed:
            if self.title == R.string.localizable.pulls(
                preferredLanguages: myLangs
            ) {
                return self.navigator.viewController(for: Router.shared.urlString(
                    host: .pull,
                    path: .list,
                    parameters: parameters
                ))!
            } else if self.title == R.string.localizable.issues(
                preferredLanguages: myLangs
            ) {
                return self.navigator.viewController(for: Router.shared.urlString(
                    host: .issue,
                    path: .list,
                    parameters: parameters
                ))!
            }
        default:
            break
        }
        let vc = UIViewController.init()
        vc.view.backgroundColor = .random
        return vc
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        PagingIndexItem(index: index, title: self.currentState.pages[index].title ?? "")
    }
}
