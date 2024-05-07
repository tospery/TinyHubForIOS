//
//  ThemeItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/30.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class ThemeItem: BaseCollectionItem, ReactorKit.Reactor {

    enum Action {
        case select(Bool?)
    }
    
    enum Mutation {
        case setSelected(Bool?)
    }

    struct State {
        var selected: Bool?
        var colorTheme: ColorTheme?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let element = (model as? BaseModel)?.data as? SectionItemElement else { return }
        if case let .theme(colorTheme) = element {
            self.initialState = State(
                colorTheme: colorTheme
            )
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .select(selected):
            return .just(.setSelected(selected))
        }
    }
                
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelected(selected):
            newState.selected = selected
        }
        return newState
    }
    
}
