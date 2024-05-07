//
//  IssueItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/9.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import BonMot
import HiIOS

class IssueItem: StateItem {

    required public init(_ model: ModelType) {
        super.init(model)
        guard let issue = model as? Issue else { return }
        self.initialState = State(
            name: issue.user?.username,
            time: issue.state == .open ? issue.createdAt?.dateAgo : issue.closedAt?.dateAgo,
            title: "#\(issue.number ?? 0) - \(issue.title ?? "")"
                .styled(with: .font(.bold(15)), .color(.foreground)),
            comment: .composed(of: [
                R.image.ic_comment()!.template
                    .styled(with: .baselineOffset(-2)),
                Special.space,
                Special.space,
                issue.comments.string
                    .attributedString()
            ]).styled(with: .font(.normal(11)), .color(.body)),
            avatar: issue.user?.avatar?.url,
            labels: issue.labels
        )
    }
    
}
