//
//  TestViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/13.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class TestViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
//        self.initialState = State(
//            title: self.title ?? R.string.localizable.test(
//                preferredLanguages: myLangs
//            )
//        )
        self.initialState.title = self.title ?? R.string.localizable.test(preferredLanguages: myLangs)
    }
    
//    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
//        .create { [weak self] observer -> Disposable in
//            guard let `self` = self else { fatalError() }
//            return self.provider.userFollowing(username: "", page: page)
//                .asObservable()
//                .map { .initial([.init(header: nil, models: $0)]) }
//                .subscribe(observer)
//        }
//    }

}
