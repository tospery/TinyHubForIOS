//
//  URLSchemeItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/27.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class URLSchemeItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var name: String?
        var url: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let scheme = model as? URLScheme else { return }
        self.initialState = State(
            name: scheme.name,
            url: scheme.url
        )
    }
    
}
