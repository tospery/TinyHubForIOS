//
//  SearchViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/18.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class SearchViewReactor: ListViewReactor {

    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState.data = self.parameters.string(for: Parameter.query)
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            let query: String = self.currentState.data as? String ?? ""
            if (self.currentState.configuration as? Configuration)?.searchIndex ?? 0 == 0 {
                return self.provider.searchRepos(
                    keyword: query,
                    language: (self.currentState.configuration as? Configuration)?.searchLanguage,
                    order: .desc,
                    page: page,
                    sort: .stars
                )
                .asObservable()
                .map {
                    mode != .loadMore ?
                        .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
                }
                .subscribe(observer)
            }
            return self.provider.searchUsers(
                keyword: query,
                degree: (self.currentState.configuration as? Configuration)?.searchDegree,
                order: .desc,
                page: page
            )
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
        }
    }
    
}
