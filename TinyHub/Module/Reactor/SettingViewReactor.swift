//
//  SettingViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/7.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import Kingfisher
import HiIOS

class SettingViewReactor: ListViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState.title = self.title ?? R.string.localizable.settings(
            preferredLanguages: self.currentState.configuration?.localization.preferredLanguages
        )
    }
    
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setConfiguration(configuration):
            newState.title = self.title ?? R.string.localizable.settings(
                preferredLanguages: configuration?.localization.preferredLanguages
            )
        default:
            break
        }
        return super.reduce(state: newState, mutation: mutation)
    }
    
    override func fetchLocal() -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            return self.calculateDiskStorageSize().map { [weak self] cache -> Mutation in
                guard let `self` = self else { fatalError() }
                return .initial(self.genContents(cache))
            }
            .subscribe(observer)
        }
    }
    
    override func active(_ value: Any?) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            return self.clearDiskCache().map { _ -> [HiContent] in
                return self.genContents("0")
            }
            .flatMap { contents -> Observable<Mutation> in
                .concat([
                    .just(.initial(contents)),
                    .just(.setTarget(Router.shared.urlString(host: .toast, parameters: [
                        Parameter.message: R.string.localizable.toastCacheMessage(preferredLanguages: myLangs)
                    ])))
                ])
            }
            .subscribe(observer)
        }
    }

    func calculateDiskStorageSize() -> Observable<String> {
        .create { observer -> Disposable in
            ImageCache.default.calculateDiskStorageSize { result in
                switch result {
                case .success(let size):
                    observer.onNext(UInt64(size).formatted)
                case .failure(let error):
                    log("获取磁盘占用缓存失败：\(error)")
                    observer.onNext("0")
                }
                observer.onCompleted()
            }
            return Disposables.create { }
        }
    }
    
    func clearDiskCache() -> Observable<Void> {
        .create { observer -> Disposable in
            ImageCache.default.clearDiskCache {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create { }
        }
    }
    
    func genContents(_ size: String) -> [HiContent] {
        var models = [ModelType].init()
        models.append(Simple.init(height: 15))
        models.append(Simple.init(
            id: CellId.theme.rawValue,
            title: CellId.theme.title,
            target: "tinyhub://theme"
        ))
        models.append(Simple.init(
            id: CellId.localization.rawValue,
            title: CellId.localization.title,
            divided: false,
            target: "tinyhub://localization"
        ))
        models.append(Simple.init(height: 15))
        models.append(Simple.init(
            id: CellId.cache.rawValue,
            title: CellId.cache.title,
            detail: size,
            divided: false
        ))
        return [.init(header: nil, models: models)]
    }
    
}
