//
//  FavoriteViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class FavoriteViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState.title = self.title ?? R.string.localizable.favorite(preferredLanguages: myLangs)
    }
    
    override func reduce(state: ListViewReactor.State, mutation: ListViewReactor.Mutation) -> ListViewReactor.State {
        var newState = state
        switch mutation {
        case let .setConfiguration(configuration):
            newState.title = self.title ?? R.string.localizable.favorite(
                preferredLanguages: configuration?.localization.preferredLanguages
            )
        default:
            break
        }
        return super.reduce(state: newState, mutation: mutation)
    }
    
    override func fetchLocal() -> Observable<Mutation> {
        let models = Repo.cachedArray(page: self.host) ?? []
        let original: [HiContent] = models.isNotEmpty ? [.init(header: nil, models: models)] : []
        return .just(.initial(original))
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let username = self.currentState.user?.username else {
                observer.onNext(.initial([]))
                observer.onCompleted()
                return Disposables.create { }
            }
            return self.provider.userStarred(username: username, page: page)
                .asObservable()
                .map {
                    mode != .loadMore ?
                        .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
                }
                .subscribe(observer)
        }
    }

}
