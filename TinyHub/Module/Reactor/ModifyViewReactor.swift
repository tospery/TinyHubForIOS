//
//  ModifyViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/8.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class ModifyViewReactor: ListViewReactor {
    
    let key: String!
    let data: String!
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        self.key = parameters?.string(for: Parameter.key)
        self.data = parameters?.string(for: Parameter.value)
        super.init(provider, parameters)
//        self.initialState = State(
//            title: self.title ?? R.string.localizable.modifyUserinfo(
//                preferredLanguages: myLangs
//            ),
//            data: self.data
//        )
        self.initialState.title = self.title ?? R.string.localizable.modifyUserinfo(preferredLanguages: myLangs)
        self.initialState.data = self.data
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        var models = [ModelType].init()
        models.append(Simple.init(height: 15))
        if self.key == CellId.bio.param {
            models.append(BaseModel.init(SectionItemElement.textView(self.data)))
        } else {
            models.append(BaseModel.init(SectionItemElement.textField(self.data)))
        }
        models.append(Simple.init(height: 30))
        models.append(BaseModel.init(SectionItemElement.button(R.string.localizable.update(
            preferredLanguages: myLangs
        ))))
        return .just(.initial([.init(header: nil, models: models)]))
    }

    override func active(_ value: Any?) -> Observable<ListViewReactor.Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let key = self.path, let value = self.currentState.data as? String else {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            return self.provider.modify(key: key, value: value)
                .asObservable()
                .map(Mutation.setUser)
                .subscribe(observer)
        }
    }
    
}
