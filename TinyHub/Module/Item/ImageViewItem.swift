//
//  ImageViewItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/25.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class ImageViewItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State {
        var image: ImageSource?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let element = (model as? BaseModel)?.data as? SectionItemElement else { return }
        if case let .imageView(image) = element {
            self.initialState = State(
                image: image
            )
        }
    }
    
}
