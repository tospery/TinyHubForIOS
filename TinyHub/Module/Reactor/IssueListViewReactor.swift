//
//  IssueListViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/9.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class IssueListViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            return self.provider.issues(
                username: self.username,
                reponame: self.reponame,
                state: self.page.state,
                page: page
            )
            .asObservable()
            .map {
                mode != .loadMore ?
                    .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
            }
            .subscribe(observer)
        }
    }

}
