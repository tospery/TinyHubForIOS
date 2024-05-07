//
//  DirSingleItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/16.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class DirSingleItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var name: String?
        var icon: ImageSource?
        var arrow: ImageSource?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let content = model as? Content else { return }
        self.initialState = State(
            name: content.name,
            icon: content.icon,
            arrow: R.image.ic_arrow_right()
        )
    }
    
}
