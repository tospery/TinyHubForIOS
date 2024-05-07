//
//  Dynamically.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/19.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import HiIOS

let dynamically = Dynamically(
    provider: MoyaProvider<DynamicTarget>(
        endpointClosure: Dynamically.endpointClosure,
        requestClosure: Dynamically.requestClosure,
        stubClosure: Dynamically.stubClosure,
        callbackQueue: Dynamically.callbackQueue,
        session: Dynamically.session,
        plugins: Dynamically.plugins,
        trackInflights: Dynamically.trackInflights
    )
)

struct Dynamically: NetworkingType {
    typealias Target = DynamicTarget
    let provider: MoyaProvider<DynamicTarget>
    
    static var plugins: [PluginType] {
        var plugins: [PluginType] = []
        let logger = HiLoggerPlugin.init()
#if DEBUG
        logger.configuration.logOptions = [.requestBody, .successResponseBody, .errorResponseBody]
#else
        logger.configuration.logOptions = [.requestBody]
#endif
        logger.configuration.output = output
        plugins.append(logger)
        return plugins
    }
    
    static func output(target: TargetType, items: [String]) {
        for item in items {
            log(item, module: .restful)
        }
    }
    
    func request(_ target: Target) -> Single<Moya.Response> {
        self.provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .catch { Single<Moya.Response>.error($0.asHiError) }
    }
    
}
