//
//  UserViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/30.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class UserViewReactor: ListViewReactor {
    
    struct Data {
        var isFollowed: Bool?
        var user: User?
    }
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState.data = UserViewReactor.Data.init()
    }
    
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = super.reduce(state: state, mutation: mutation)
        switch mutation {
        case let .setData(data):
            newState.title = (data as? UserViewReactor.Data)?.user?.type
        default:
            break
        }
        return newState
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .merge([
            self.provider.user(username: self.username)
                .asObservable()
                .flatMap { [weak self] user -> Observable<Mutation> in
                    guard let `self` = self else { return .empty() }
                    var user = user
                    user.style = .detail
                    var data = self.currentState.data as? UserViewReactor.Data
                    data?.user = user
                    var models = [ModelType].init()
                    models.append(user)
                    if user.isOrganization {
                        models.append(Simple.init(height: 15))
                    } else {
                        models.append(Simple.init(height: 15))
                    }
                    models.append(
                        contentsOf: [
                            CellId.company, CellId.location, CellId.email, CellId.blog
                        ].map { id -> Simple in
                            var indicated = true
                            switch id {
                            case .company: indicated = user.company?.isNotEmpty ?? false
                            case .location: indicated = user.location?.isNotEmpty ?? false
                            case .email: indicated = user.email?.isNotEmpty ?? false
                            case .blog: indicated = user.blog?.isNotEmpty ?? false
                            default: break
                            }
                            return .init(
                                id: id.rawValue, icon: id.icon, title: id.title, indicated: indicated
                            )
                        }
                    )
                    return .concat([
                        .just(.setData(data)),
                        .just(.initial([.init(header: nil, models: models)]))
                    ])
                },
            self.provider.checkFollowing(username: self.username)
                .asObservable()
                .catchAndReturn(false)
                .flatMap { [weak self] isFollowed -> Observable<Mutation> in
                    guard let `self` = self else { return .empty() }
                    var data = self.currentState.data as? UserViewReactor.Data
                    data?.isFollowed = isFollowed
                    return .just(.setData(data))
                }
        ])
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
                    return self.provider.checkFollowing(username: self.username)
                        .catchAndReturn(false)
                        .asObservable()
                        .flatMap { isFollowed -> Observable<Mutation> in
                            if isFollowed {
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
    
    override func active(_ value: Any?) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard self.currentState.user?.isValid ?? false else {
                observer.onError(HiError.userNotLoginedIn)
                return Disposables.create { }
            }
            var data = self.currentState.data as? UserViewReactor.Data
            if data?.isFollowed ?? false {
                return self.provider.unfollowUser(username: self.username)
                    .asObservable()
                    .map { _ -> Mutation in
                        data?.isFollowed = false
                        return .setData(data)
                    }
                    .subscribe(observer)
            }
            return self.provider.followUser(username: self.username)
                .asObservable()
                .map { _ -> Mutation in
                    data?.isFollowed = true
                    return .setData(data)
                }
                .subscribe(observer)
        }
    }

}
