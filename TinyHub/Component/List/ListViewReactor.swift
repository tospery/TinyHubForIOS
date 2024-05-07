//
//  ListViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import RxSwiftExt
import RxOptional
import URLNavigator_Hi
import Rswift
import HiIOS

class ListViewReactor: GeneralViewReactor {
    
    let page: Page
    let username: String
    let reponame: String

    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        self.page = parameters?.enum(for: Parameter.page, type: Page.self) ?? Page.none
        self.username = parameters?.string(for: Parameter.username) ?? ""
        self.reponame = parameters?.string(for: Parameter.reponame) ?? ""
        super.init(provider, parameters)
        self.initialState.user = User.current
        self.initialState.configuration = Configuration.current!
    }
    
    override func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        .merge(
            mutation,
            Subjection.for(User.self)
                .distinctUntilChanged()
                .asObservable()
                .map(Mutation.setUser),
            Subjection.for(Configuration.self)
                .distinctUntilChanged()
                .filterNil()
                .asObservable()
                .map(Mutation.setConfiguration)
        )
    }
    
    // swiftlint:disable cyclomatic_complexity
    override func convert(contents: [HiContent]) -> [any SectionModelType] {
        (contents.count == 0 ? [] : contents.map {
            Section.sectionItems(header: $0.header, items: $0.models.map {
                if let value = ($0 as? BaseModel)?.data as? SectionItemElement {
                    return value.sectionItem($0)
                }
                if let user = $0 as? User {
                    switch user.style {
                    case .plain: return .userPlain(.init($0))
                    case .basic: return .userBasic(.init($0))
                    case .detail: return .userDetail(.init($0))
                    }
                }
                if let repo = $0 as? Repo {
                    switch repo.style {
                    case .plain, .basic: return .repoBasic(.init($0))
                    case .detail: return .repoDetail(.init($0))
                    }
                }
                if let content = $0 as? Content {
                    if content.isReadme {
                        return .readmeContent(.init($0))
                    }
                    return content.children.count == 0 ? .dirSingle(.init($0)) : .dirMultiple(.init($0))
                }
                if $0 is URLScheme {
                    return .urlScheme(.init($0))
                }
                if $0 is Event {
                    return .event(.init($0))
                }
                if $0 is Issue {
                    return .issue(.init($0))
                }
                if $0 is Language {
                    return .language(.init($0))
                }
                if $0 is Degree {
                    return .degree(.init($0))
                }
                if $0 is Branch {
                    return .branch(.init($0))
                }
                if $0 is Pull {
                    return .pull(.init($0))
                }
                return .simple(.init($0))
            })
        })
    }
    // swiftlint:enable cyclomatic_complexity

}
