//
//  RepoDetailItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/28.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class RepoDetailItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var desc: String?
        var update: String?
        var name: NSAttributedString?
        var lang: NSAttributedString?
        var avatar: ImageSource?
        var repo: Repo?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        self.initialState = State(
            desc: repo.desc ?? R.string.localizable.noneDesc(
                preferredLanguages: myLangs
            ),
            update: repo.updateAgo,
            name: repo.fullnameAttributedText,
            lang: repo.languageAttributedText
                .styled(with: .font(.normal(13))),
            avatar: repo.owner.avatar?.url,
            repo: repo
        )
    }
    
}
