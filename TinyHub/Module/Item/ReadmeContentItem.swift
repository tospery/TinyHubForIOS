//
//  ReadmeContentItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/20.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class ReadmeContentItem: BaseCollectionItem, ReactorKit.Reactor {

    enum Action {
        case html(String?)
    }
    
    enum Mutation {
        case setHtml(String?)
    }
    
    struct State {
        var html: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let content = model as? Content else { return }
        self.initialState = State(
            html: content.htmlString
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .html(html):
            return .just(.setHtml(html))
        }
    }
                
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setHtml(html):
            newState.html = html
        }
        return newState
    }
    
}
