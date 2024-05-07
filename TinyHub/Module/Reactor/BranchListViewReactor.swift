//
//  BranchListViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/18.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class BranchListViewReactor: ListViewReactor {
    
    struct Data {
        var selected: String?
        var branches: [Branch]?
    }
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
//        self.initialState = State(
//            title: self.title ?? R.string.localizable.branches(
//                preferredLanguages: myLangs
//            ),
//            data: BranchListViewReactor.Data.init(
//                selected: self.parameters.string(for: Parameter.selected)
//            )
//        )
        self.initialState.title = self.title ?? R.string.localizable.branches(preferredLanguages: myLangs)
        self.initialState.data = BranchListViewReactor.Data.init(
            selected: self.parameters.string(for: Parameter.selected)
        )
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        self.provider.branches(username: self.username, reponame: self.reponame, page: page)
            .asObservable()
            .map {
                mode != .loadMore ?
                    .initial([.init(header: nil, models: $0)]) : .append([.init(header: nil, models: $0)])
            }
    }

}
