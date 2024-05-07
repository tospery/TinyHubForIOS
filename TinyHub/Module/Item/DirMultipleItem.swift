//
//  DirMultipleItem.swift
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

class DirMultipleItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var children: [Content]?
        var total = [HiContent].init()
        var sections = [Section].init()
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard var content = model as? Content else { return }
        var children = content.children
        content.children = []
        content.unfold = true
        children.insert(content, at: 0)
        let total: [HiContent] = [.init(header: nil, models: children)]
        let sections: [Section] = total.map {
            .sectionItems(header: $0.header, items: $0.models.map {
                if let content = $0 as? Content {
                    return content.children.count == 0 ? .dirSingle(.init($0)) : .dirMultiple(.init($0))
                }
                return .simple(.init($0))
            })
        }
//        let sections: [Section] = total.map {
//            .sectionItems(header: $0.header, items: $0.models.map { .dirSingle(.init($0)) })
//        }
        self.initialState = State(
            children: children,
            total: total,
            sections: sections
        )
    }
    
}
