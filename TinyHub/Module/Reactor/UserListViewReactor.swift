//
//  UserListViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/3.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class UserListViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.pageStart = 0
        self.pageIndex = self.pageStart
    }
    
    override func fetchLocal() -> Observable<Mutation> {
        let models = User.cachedArray(page: self.page.rawValue) ?? []
        let original: [HiContent] = models.isNotEmpty ? [.init(header: nil, models: models)] : []
        return .just(.initial(original))
    }

    // swiftlint:disable function_body_length
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            let configuration = self.currentState.configuration as? Configuration
            switch self.page {
            case .trendingUsers:
                return self.provider.trendingUsers(
                    language: configuration?.trendingLanguage, since: configuration?.trendingSince
                )
                    .asObservable()
                    .map {
                        mode != .loadMore ?
                            .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
                    }
                    .subscribe(observer)
            case .followers:
                return self.provider.userFollowers(username: self.username, page: page)
                     .asObservable()
                     .map { $0.map { user -> User in
                         var user = user
                         user.style = .plain
                         return user
                        }
                     }
                     .map {
                         mode != .loadMore ?
                             .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
                     }
                     .subscribe(observer)
            case .following:
                return self.provider.userFollowing(username: self.username, page: page)
                     .asObservable()
                     .map { $0.map { user -> User in
                         var user = user
                         user.style = .plain
                         return user
                        }
                     }
                     .map {
                         mode != .loadMore ?
                             .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
                     }
                     .subscribe(observer)
            case .watchers:
                return self.provider.repoWatchers(username: self.username, reponame: self.reponame, page: page)
                     .asObservable()
                     .map { $0.map { user -> User in
                         var user = user
                         user.style = .plain
                         return user
                        }
                     }
                     .map {
                         mode != .loadMore ?
                             .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
                     }
                     .subscribe(observer)
            case .stargazers:
                return self.provider.repoStargazers(username: self.username, reponame: self.reponame, page: page)
                     .asObservable()
                     .map { $0.map { user -> User in
                         var user = user
                         user.style = .plain
                         return user
                        }
                     }
                     .map {
                         mode != .loadMore ?
                             .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
                     }
                     .subscribe(observer)
            case .contributors:
                return self.provider.repoContributors(username: self.username, reponame: self.reponame, page: page)
                     .asObservable()
                     .map { $0.map { user -> User in
                         var user = user
                         user.style = .plain
                         return user
                        }
                     }
                     .map {
                         mode != .loadMore ?
                             .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
                     }
                     .subscribe(observer)
            default:
                observer.onNext(.initial([.init(header: nil, models: [])]))
                observer.onCompleted()
                return Disposables.create { }
            }
        }
    }
    // swiftlint:enable function_body_length

}
