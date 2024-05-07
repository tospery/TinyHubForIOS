//
//  MilestoneItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/31.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class MilestoneItem: BaseCollectionItem, ReactorKit.Reactor {

    enum Action {
        case url(String?)
    }
    
    enum Mutation {
        case setUrl(String?)
    }

    struct State {
        var url: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
//        self.initialState = State(
//            url: "https://ghchart.rshah.org/1CA035/tospery"
//        )
    }
    
}
