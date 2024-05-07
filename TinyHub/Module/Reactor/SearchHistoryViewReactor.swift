//
//  SearchHistoryViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/3.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import BonMot
import HiIOS

class SearchHistoryViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var sections = [HiContent].init()
            if (self.currentState.configuration as? Configuration)?.keywords.count ?? 0 != 0 {
                sections.append(
                    .init(
                        header: BaseModel.init([
                            R.image.ic_search_history()!,
                            R.string.localizable.searchHistory(
                                preferredLanguages: myLangs
                            ),
                            R.image.ic_search_erase()!
                        ] as [Any]),
                        models: [BaseModel.init(SectionItemElement.searchKeywords)]
                    )
                )
            } else {
                sections.append(
                    .init(
                        header: nil,
                        models: [
                            BaseModel.init(
                                SectionItemElement.label(.init(
                                    attributedText: R.string.localizable.searchHistoryEmpty(
                                        preferredLanguages: myLangs
                                    )
                                        .styled(with: .font(.normal(14)), .color(.body)),
                                    alignment: .center,
                                    links: [:],
                                    color: .background
                                ))
                            )
                        ]
                    )
                )
            }
            observer.onNext(.initial(sections))
            observer.onCompleted()
            return Disposables.create { }
        }
    }

}
