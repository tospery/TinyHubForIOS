//
//  PullItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/18.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import BonMot
import HiIOS

class PullItem: StateItem {

    required public init(_ model: ModelType) {
        super.init(model)
        guard let pull = model as? Pull else { return }
        self.initialState = State(
            name: pull.user?.username,
            time: pull.state == .open ? pull.createdAt?.dateAgo : pull.closedAt?.dateAgo,
            title: "#\(pull.number ?? 0) - \(pull.title ?? "")"
                .styled(with: .font(.bold(15)), .color(.foreground)),
            comment: .composed(of: [
                R.image.ic_comment()!.template
                    .styled(with: .baselineOffset(-2)),
                Special.space,
                0.string
                    .attributedString()
            ]).styled(with: .font(.normal(11)), .color(.body)),
            avatar: pull.user?.avatar?.url,
            labels: pull.labels
        )
    }
    
}
