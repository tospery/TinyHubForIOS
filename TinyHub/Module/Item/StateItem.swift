//
//  StateItem.swift
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
import BonMot
import HiIOS

class StateItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State {
        var name: String?
        var time: String?
        var title: NSAttributedString?
        var comment: NSAttributedString?
        var avatar: ImageSource?
        var labels: [Label]?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
    }
    
}
