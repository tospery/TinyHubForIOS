//
//  UserPlainItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/10.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class UserPlainItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var name: String?
        var url: String?
        var avatar: ImageSource?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            name: user.username,
            url: user.htmlUrl,
            avatar: user.avatar?.url
        )
    }
    
}
