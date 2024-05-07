//
//  UserBasicItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/5.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import BonMot
import HiIOS

class UserBasicItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var user: String?
        var desc: String?
        var repo: NSAttributedString?
        var avatar: ImageSource?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
//            user: user.nickname?.isNotEmpty ?? false ? user.fullname :
//                (user.username ?? R.string.localizable.unknown(preferredLanguages: myLangs)),
            user: user.fullname,
            desc: user.repo?.desc ?? R.string.localizable.noneDesc(
                preferredLanguages: myLangs
            ),
            repo: user.repoAttributedText,
            avatar: user.avatar?.url
        )
    }
    
}
