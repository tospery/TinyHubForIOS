//
//  SimpleCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class SimpleCell: HiIOS.SimpleCell {
    
    // swiftlint:disable cyclomatic_complexity function_body_length
    override func bind(reactor: HiIOS.SimpleItem) {
        super.bind(reactor: reactor)
        guard let simple = reactor.model as? Simple else { return }
        guard let list = reactor.parent as? ListViewReactor else { return }
        guard let cellId = CellId.init(rawValue: simple.id) else { return }
        if cellId == .branches {
            list.state.map {
                ($0.data as? RepoViewReactor.Data)?.defaultBranch
            }
                .distinctUntilChanged()
                .map(Reactor.Action.detail)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        } else if cellId == .pulls {
            list.state.map {
                ($0.data as? RepoViewReactor.Data)?.pullsCount
            }
                .distinctUntilChanged()
                .map(Reactor.Action.detail)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        } else if cellId == .language || cellId == .issues {
            list.state.map {
                ($0.data as? RepoViewReactor.Data)?.repo?.text(cellId: cellId)
            }
                .distinctUntilChanged()
                .map(Reactor.Action.detail)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        } else if cellId == .theme {
            list.state.map {
                ($0.configuration as? Configuration)?.theme.description
            }
                .distinctUntilChanged()
                .map(Reactor.Action.detail)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        } else if cellId == .localization {
            list.state.map {
                $0.configuration?.localization.description
            }
                .distinctUntilChanged()
                .map(Reactor.Action.detail)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        } else {
            if list.host == .user {
                if cellId.rawValue >= CellId.company.rawValue && cellId.rawValue <= CellId.bio.rawValue {
                    list.state.map {
                        ($0.data as? UserViewReactor.Data)?.user?.text(cellId: cellId)
                    }
                        .distinctUntilChanged()
                        .map(Reactor.Action.title)
                        .bind(to: reactor.action)
                        .disposed(by: self.disposeBag)
                }
            } else {
                let onTitle = list.host == .personal
                if cellId.rawValue >= CellId.company.rawValue && cellId.rawValue <= CellId.bio.rawValue {
                    list.state.map { ($0.user as? User)?.text(cellId: cellId) }
                        .distinctUntilChanged()
                        .map { onTitle ? Reactor.Action.title($0) : Reactor.Action.detail($0) }
                        .bind(to: reactor.action)
                        .disposed(by: self.disposeBag)
                }
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length
    
}
