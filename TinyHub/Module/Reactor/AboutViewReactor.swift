//
//  AboutViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class AboutViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
//        self.initialState = State(
//            title: self.title ?? R.string.localizable.about(
//                preferredLanguages: myLangs
//            )
//        )
        self.initialState.title = self.title ?? R.string.localizable.about(preferredLanguages: myLangs)
    }
    
    override func fetchLocal() -> Observable<Mutation> {
        var models = [ModelType].init()
        models.append(contentsOf: [
            CellId.author, CellId.qqgroup, CellId.space, CellId.schemes, CellId.score, CellId.share
        ].map {
            Simple.init(
                id: $0.rawValue,
                title: $0.title,
                indicated: true,
                divided: $0 != .qqgroup && $0 != .share,
                target: $0.target
            )
        })
        return .just(.initial([.init(header: nil, models: models)]))
    }

}
