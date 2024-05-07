//
//  OptionsViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2024/3/23.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class OptionsViewReactor: ListViewReactor {
    
    struct Data {
        var index: Int?
        var query: String?
        var language: Language?
        var degree: Degree?
    }
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        let configuration = (self.currentState.configuration as? Configuration) ?? .init()
        self.initialState.title = self.title ?? R.string.localizable.language(
            preferredLanguages: myLangs
        )
        self.initialState.data = OptionsViewReactor.Data.init(
            index: configuration.searchIndex,
            query: nil,
            language: self.host == .trending ? configuration.trendingLanguage : configuration.searchLanguage,
            degree: configuration.searchDegree
        )
    }
    
    override func reduce(
        state: GeneralViewReactor.State,
        mutation: GeneralViewReactor.Mutation
    ) -> GeneralViewReactor.State {
        var newState = state
        switch mutation {
        case let .setData(data):
            let index = (data as? OptionsViewReactor.Data)?.index
            var configuration = newState.configuration as? Configuration
            log("切换了搜索栏的index: \(configuration?.searchIndex ?? 0) -> \(index ?? 0)")
            configuration?.searchIndex = index ?? 0
            newState.configuration = configuration
        default:
            break
        }
        return super.reduce(state: newState, mutation: mutation)
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var models = [ModelType].init()
            let query = (self.currentState.data as? OptionsViewReactor.Data)?.query
            if self.host == .trending {
                var languages = Language.cachedArray() ?? []
                languages.insert(.any, at: 0)
                if query?.isNotEmpty ?? false {
                    languages = languages.filter { $0.name?.contains(query!, caseSensitive: false) ?? false }
                }
                models.append(contentsOf: languages)
            } else {
                let index = (self.currentState.data as? OptionsViewReactor.Data)?.index
                if index == 0 {
                    var languages = Language.cachedArray() ?? []
                    languages.insert(.any, at: 0)
                    if query?.isNotEmpty ?? false {
                        languages = languages.filter { $0.name?.contains(query!, caseSensitive: false) ?? false }
                    }
                    models.append(contentsOf: languages)
                } else {
                    var degrees = Degree.cachedArray() ?? []
                    if query?.isNotEmpty ?? false {
                        degrees = degrees.filter { $0.id.contains(query!, caseSensitive: false) }
                    }
                    models.append(contentsOf: degrees)
                }
            }
            observer.onNext(.initial([.init(header: nil, models: models)]))
            observer.onCompleted()
            return Disposables.create { }
        }
    }
    
    override func silent(_ value: Any?) -> Observable<Mutation> {
        .concat([
            .create { [weak self] observer -> Disposable in
                guard let `self` = self else { fatalError() }
                var myData = self.currentState.data as? OptionsViewReactor.Data
                if let query = value as? String {
                    myData?.query = query
                    observer.onNext(.setData(myData))
                } else {
                    var configuration = self.currentState.configuration as? Configuration ?? .init()
                    if self.host == .search {
                        configuration.searchIndex = myData?.index ?? 0
                        if let language = value as? Language {
                            myData?.language = language
                            // myData?.degree = nil
                            configuration.searchLanguage = language
                            // configuration.searchDegree = nil
                        } else if let degree = value as? Degree {
                            // myData?.language = nil
                            myData?.degree = degree
                            // configuration.searchLanguage = nil
                            configuration.searchDegree = degree
                        }
                    } else {
                        if let language = value as? Language {
                            myData?.language = language
                            configuration.trendingLanguage = language
                        }
                    }
                    observer.onNext(.setData(myData))
                    observer.onNext(.setConfiguration(configuration))
                }
                observer.onCompleted()
                return Disposables.create { }
            },
            self.load()
        ])
    }

}
