//
//  ButtonItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/6.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class ButtonItem: BaseCollectionItem, ReactorKit.Reactor {

    enum Action {
        case enable(Bool?)
    }
    
    enum Mutation {
        case setEnabled(Bool?)
    }

    struct State {
        var enabled: Bool?
        var title: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let value = (model as? BaseModel)?.data as? SectionItemElement else { return }
        if case let .button(title) = value {
            self.initialState = State(
                title: title
            )
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .enable(isEnabled):
            return .just(.setEnabled(isEnabled))
        }
    }
        
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setEnabled(enabled):
            newState.enabled = enabled
        }
        return newState
    }
    
}
