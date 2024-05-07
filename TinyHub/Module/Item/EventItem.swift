//
//  EventItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/7.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class EventItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setContent([NSAttributedString]?)
    }

    struct State {
        var title: String?
        var time: String?
        var content: [NSAttributedString]?
        var icon: ImageSource?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let event = model as? Event else { return }
        self.initialState = State(
            title: event.type.title,
            time: event.time,
            content: event.content,
            icon: event.type.icon
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setContent(content):
            newState.content = content
        }
        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        .merge(
           mutation,
           themeService.typeStream.skip(1)
            .map { [weak self] _ -> [NSAttributedString]? in
                guard let `self` = self else { return nil }
                guard let event = self.model as? Event else { return nil }
                return event.content
            }
            .map(Mutation.setContent)
       )
    }
    
}
