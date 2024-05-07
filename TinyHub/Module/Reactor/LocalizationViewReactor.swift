//
//  LocalizationViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/29.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class LocalizationViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState.title = self.title ?? R.string.localizable.language(preferredLanguages: myLangs)
        self.initialState.data = self.currentState.configuration?.localization
    }
    
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = super.reduce(state: state, mutation: mutation)
        switch mutation {
        case let .setConfiguration(configuration):
            newState.data = configuration?.localization
        default:
            break
        }
        return newState
    }
    
    override func fetchLocal() -> Observable<Mutation> {
        let models = Localization.allValues.map {
            BaseModel.init(
                SectionItemElement.check($0)
            )
        }
        return .just(.initial([.init(header: nil, models: models)]))
    }

}
