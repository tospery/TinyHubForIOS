//
//  PersonalViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class PersonalViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState.title = self.title ?? R.string.localizable.personal(preferredLanguages: myLangs)
    }
    
    override func reduce(state: ListViewReactor.State, mutation: ListViewReactor.Mutation) -> ListViewReactor.State {
        var newState = state
        switch mutation {
        case let .setConfiguration(configuration):
            newState.title = self.title ?? R.string.localizable.personal(
                preferredLanguages: configuration?.localization.preferredLanguages
            )
        default:
            break
        }
        return super.reduce(state: newState, mutation: mutation)
    }
    
    override func update() -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let username = self.currentState.user?.username, username.isNotEmpty else {
                return Disposables.create { }
            }
            return self.provider.user(username: username)
                .asObservable()
                .map(Mutation.setUser)
                .subscribe(observer)
        }.catch {
            .just(.setError($0))
        }
    }
    
    override func fetchLocal() -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            observer.onNext(.initial(self.section(self.currentState.user as? User)))
            observer.onCompleted()
            return Disposables.create { }
        }
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            observer.onNext(.initial(self.section(self.currentState.user as? User)))
            observer.onCompleted()
            return Disposables.create { }
        }
    }
    
    func section(_ user: User?) -> [HiContent] {
        var models = [ModelType].init()
        if user?.isValid ?? false {
            models.append(contentsOf: [CellId.company, CellId.location, CellId.email].map {
                Simple.init(id: $0.rawValue, icon: $0.icon, indicated: false, divided: true)
            })
            models.append(Simple.init(
                id: CellId.blog.rawValue,
                icon: CellId.blog.icon,
                title: user?.blog,
                indicated: true,
                divided: true,
                target: user?.blog
            ))
        }
        models.append(Simple.init())
        models.append(contentsOf: [CellId.settings, CellId.about, CellId.feedback].map {
            Simple.init(
                id: $0.rawValue,
                icon: $0.icon,
                title: $0.title,
                indicated: true,
                divided: $0 != .feedback,
                target: $0.target
            )
        })
        return [.init(header: nil, models: models)]
    }

}
