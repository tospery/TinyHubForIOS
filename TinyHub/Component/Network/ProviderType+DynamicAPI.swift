//
//  ProviderType+DynamicAPI.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/19.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import HiIOS

extension ProviderType {
    
    func file(urlString: String) -> Single<Any> {
        let url = urlString.apiString.url
        let base = url?.baseString ?? UIApplication.shared.baseApiUrl
        let path = (url?.pathString ?? "").urlDecoded
        let parameters = url?.queryParameters
        return dynamically.requestRaw(
            DynamicTarget.init(
                baseURL: base.url!,
                target: DynamicAPI.request(path: path, parameters: parameters)
            )
        )
        .flatMap { response in
            if let string = try? response.mapString() {
                return .just(string)
            }
            if let image = try? response.mapImage() {
                return .just(image)
            }
            return .error(HiError.dataInvalid)
        }
    }

}
