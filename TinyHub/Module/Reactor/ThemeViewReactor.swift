//
//  ThemeViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/30.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class ThemeViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState.title = self.title ?? R.string.localizable.theme(preferredLanguages: myLangs)
        self.initialState.data = (self.currentState.configuration as? Configuration)?.theme
    }
    
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = super.reduce(state: state, mutation: mutation)
        switch mutation {
        case let .setConfiguration(configuration):
            newState.data = (configuration as? Configuration)?.theme
        default:
            break
        }
        return newState
    }
    
    override func fetchLocal() -> Observable<Mutation> {
        let models = ColorTheme.allValues.map {
            BaseModel.init(
                SectionItemElement.theme($0)
            )
        }
        return .just(.initial([.init(header: nil, models: models)]))
    }

}
