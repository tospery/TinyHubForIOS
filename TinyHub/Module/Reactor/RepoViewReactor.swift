//
//  RepoViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class RepoViewReactor: ListViewReactor {
    
    struct Data {
        var isStarred: Bool?
        var repo: Repo?
        var readme: Content?
        var branch: Branch?
        var branches: [Branch]?
        var pulls: [Pull]?
        
        var defaultBranch: String? {
            guard let name = self.branch?.id, name.isNotEmpty else { return "-" }
            guard let count = self.branches?.count, count != 0 else { return "-" }
            return "\(count)(\(name))"
        }
        
        var pullsCount: String? {
            guard let count = self.pulls?.count else { return "-" }
            return count.string
        }
    }
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState.title = self.title ?? R.string.localizable.repository(preferredLanguages: myLangs)
        self.initialState.data = RepoViewReactor.Data.init()
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .merge([
            .concat([
                self.requestRepo(),
                .concat([
                    self.requestReadmeContent(),
                    self.requestReadmeHtml()
                ])
            ]),
            self.provider.checkStarring(username: self.username, reponame: self.reponame)
                .asObservable()
                .catchAndReturn(false)
                .flatMap { [weak self] isStarred -> Observable<Mutation> in
                    guard let `self` = self else { return .empty() }
                    var data = self.currentState.data as? RepoViewReactor.Data
                    data?.isStarred = isStarred
                    return .just(.setData(data))
                },
            self.provider.pulls(username: self.username, reponame: self.reponame, state: .open, page: self.pageStart)
                .asObservable()
                .catchAndReturn([])
                .flatMap { [weak self] pulls -> Observable<Mutation> in
                    guard let `self` = self else { return .empty() }
                    var data = self.currentState.data as? RepoViewReactor.Data
                    data?.pulls = pulls
                    return .just(.setData(data))
                },
            self.provider.branches(username: self.username, reponame: self.reponame, page: self.pageStart)
                .asObservable()
                .catchAndReturn([])
                .flatMap { [weak self] branches -> Observable<Mutation> in
                    guard let `self` = self else { return .empty() }
                    var data = self.currentState.data as? RepoViewReactor.Data
                    data?.branches = branches
                    log("看看数据: \(branches), \(branches.count)")
                    if let repo = data?.repo {
                        data?.branch = repo.branch(in: branches)
                    }
                    return .just(.setData(data))
                }
        ])
    }
    
    func requestRepo() -> Observable<Mutation> {
        self.provider.repo(username: self.username, reponame: self.reponame)
            .asObservable()
            .flatMap { [weak self] repo -> Observable<Mutation> in
                guard let `self` = self else { return .empty() }
                var repo = repo
                repo.style = .detail
                repo.languageColor =
                    repo.languageColor?.color != nil ? repo.languageColor : UIColor.random.hexString
                var data = self.currentState.data as? RepoViewReactor.Data
                data?.repo = repo
                if let branches = data?.branches, branches.isNotEmpty {
                    data?.branch = repo.branch(in: branches)
                }
                var models = [ModelType].init()
                models.append(repo)
                let cellIds: [CellId] = [.space, .language, .issues, .pulls, .space, .branches, .readme]
                let simples = cellIds.map { id -> Simple in
                    if id == .space {
                        return .init(height: 10)
                    }
                    var title = id.title
                    if title?.isEmpty ?? true {
                        if id == .language {
                            title = repo.language ?? R.string.localizable.unknown(
                                preferredLanguages: myLangs
                            )
                        }
                    }
                    return .init(id: id.rawValue, icon: id.icon, title: title)
                }
                models.append(contentsOf: simples)
                return .concat([
                    .just(.setData(data)),
                    .just(.initial([.init(header: nil, models: models)]))
                ])
            }
    }
    
    func requestReadmeContent() -> Observable<Mutation> {
        self.provider.readme(username: self.username, reponame: self.reponame, ref: nil)
            .asObservable()
            .flatMap { [weak self] readme -> Observable<Mutation> in
                guard let `self` = self else { return .empty() }
                var data = self.currentState.data as? RepoViewReactor.Data
                data?.readme = readme
                return .just(.setData(data))
            }
    }
    
    func requestReadmeHtml() -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard var readme = (self.currentState.data as? RepoViewReactor.Data)?.readme,
                  let content = readme.content,
                  let data = Foundation.Data.init(base64Encoded: content, options: .ignoreUnknownCharacters),
                  let text = String.init(data: data, encoding: .utf8) else {
                observer.onCompleted()
                return Disposables.create { }
            }
            var myData = self.currentState.data as? RepoViewReactor.Data
            var myModels = self.currentState.contents.first?.models ?? []
            return self.provider.markdown(text: text)
                .asObservable()
                .flatMap { html -> Observable<Mutation> in
                    readme.isReadme = true
                    readme.htmlString = html
                    myData?.readme = readme
                    myModels.append(readme)
                    return .concat([
                        .just(.setData(myData)),
                        .just(.initial([.init(header: nil, models: myModels)]))
                    ])
                }
                .subscribe(observer)
        }
    }
    
    override func silent(_ value: Any?) -> Observable<Mutation> {
        guard let readme = value as? Content else { return .empty() }
        return .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var data = self.currentState.data as? RepoViewReactor.Data
            data?.readme = readme
            observer.onNext(.setData(data))
            var models = self.currentState.contents.first?.models ?? []
            models.removeLast()
            models.append(readme)
            observer.onNext(.initial([.init(header: nil, models: models)]))
            observer.onCompleted()
            return Disposables.create { }
        }
    }
    
    override func active(_ value: Any?) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard self.currentState.user?.isValid ?? false else {
                observer.onError(HiError.userNotLoginedIn)
                return Disposables.create { }
            }
            var data = self.currentState.data as? RepoViewReactor.Data
            if data?.isStarred ?? false {
                return self.provider.unstarRepo(username: self.username, reponame: self.reponame)
                    .asObservable()
                    .map { _ -> Mutation in
                        data?.isStarred = false
                        return .setData(data)
                    }
                    .subscribe(observer)
            }
            return self.provider.starRepo(username: self.username, reponame: self.reponame)
                .asObservable()
                .map { _ -> Mutation in
                    data?.isStarred = true
                    return .setData(data)
                }
                .subscribe(observer)
        }
    }
    
    override func loginIfNeed() -> Observable<ListViewReactor.Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            if self.currentState.user?.isValid ?? false {
                observer.onCompleted()
                return Disposables.create { }
            }
            return Observable<Mutation>.concat([
                self.navigator.rxLogin()
                    .map { Mutation.setUser($0 as? User) },
                .create { [weak self] observer -> Disposable in
                    guard let `self` = self else { fatalError() }
                    return self.provider.checkStarring(username: self.username, reponame: self.reponame)
                        .catchAndReturn(false)
                        .asObservable()
                        .flatMap { isStarred -> Observable<Mutation> in
                            if isStarred {
                                return .error(HiError.none)
                            }
                            return .empty()
                        }
                        .subscribe(observer)
                }
            ])
            .subscribe(observer)
        }
    }

}
