//
//  SearchKeywordsItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/17.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class SearchKeywordsItem: BaseCollectionItem, ReactorKit.Reactor {

    enum Action {
        case keywords([String])
    }
    
    enum Mutation {
        case setKeywords([String])
    }

    struct State {
        var keywords = [String].init()
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .keywords(keywords):
            return .just(.setKeywords(keywords))
        }
    }
        
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setKeywords(keywords):
            newState.keywords = keywords
        }
        return newState
    }
    
    func transform(action: Observable<NoAction>) -> Observable<NoAction> {
        action
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        mutation
    }

    func transform(state: Observable<State>) -> Observable<State> {
        state
    }
    
}
