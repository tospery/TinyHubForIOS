//
//  TabBarReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class TabBarReactor: HiIOS.TabBarReactor, ReactorKit.Reactor {

    typealias Action = NoAction

    struct State {
        let keys: [TabBarKey] = [
            .trending, .event, .favorite, .personal
        ]
    }

    var initialState = State()

    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
        )
    }

}
