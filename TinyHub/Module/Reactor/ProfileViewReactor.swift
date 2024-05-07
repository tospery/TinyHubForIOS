//
//  ProfileViewReactor.swift
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

class ProfileViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
//        self.initialState = State(
//            title: self.title ?? self.currentState.user?.username
//        )
        self.initialState.title = self.title ?? self.currentState.user?.username
    }
    
    override func fetchLocal() -> Observable<Mutation> {
        var models = [ModelType].init()
        models.append(Simple.init(height: 15))
        models.append(contentsOf: [
            CellId.nickname, CellId.bio, CellId.space, CellId.company, CellId.location, CellId.blog
        ].map {
            Simple.init(
                id: $0.rawValue,
                title: $0.title,
                indicated: true,
                divided: $0 != .bio && $0 != .blog,
                target: $0.target
            )
        })
        models.append(Simple.init())
        models.append(Simple.init(
            id: CellId.button.rawValue,
            title: R.string.localizable.exitLogin(preferredLanguages: myLangs),
            color: UIColor.background.hexString,
            tintColor: UIColor.primary.hexString,
            target: Router.shared.urlString(host: .sheet, parameters: [
                Parameter.message: R.string.localizable.alertLogoutMessage(
                    preferredLanguages: myLangs
                ),
                Parameter.actions: [
                    SHAlertAction.exit.title,
                    SHAlertAction.cancel.title
                ].jsonString() ?? ""
            ])
        ))
        return .just(.initial([.init(header: nil, models: models)]))
    }

}
