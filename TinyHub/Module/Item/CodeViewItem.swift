//
//  CodeViewItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/17.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class CodeViewItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State {
        var lang: String?
        var code: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let element = (model as? BaseModel)?.data as? SectionItemElement else { return }
        if case let .codeView(lang, code) = element {
            self.initialState = State(
                lang: lang,
                code: code
            )
        }
    }
    
}
