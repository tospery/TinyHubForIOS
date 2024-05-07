//
//  URLSchemeListViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/27.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class URLSchemeListViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
//        self.initialState = State(
//            title: self.title ?? R.string.localizable.urlSchemes(
//                preferredLanguages: myLangs
//            )
//        )
        self.initialState.title = self.title ?? R.string.localizable.urlSchemes(preferredLanguages: myLangs)
    }
    
    override func fetchLocal() -> Observable<ListViewReactor.Mutation> {
        guard let urlSchemes = URLScheme.cachedArray() else { return .empty() }
        return .just(.initial([.init(header: nil, models: urlSchemes)]))
    }

}
