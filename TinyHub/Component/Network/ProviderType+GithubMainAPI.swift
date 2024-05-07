//
//  ProviderType+GithubMainAPI.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import HiIOS

extension ProviderType {

    func token(code: String) -> Single<AccessToken> {
        networking.requestObject(
            MultiTarget.init(
                GithubMainAPI.token(code: code)
            ),
            type: AccessToken.self
        )
    }
    
}
