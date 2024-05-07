//
//  GithubMainAPI.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import Moya
import SwifterSwift
import HiIOS

enum GithubMainAPI {
    case token(code: String)
}

extension GithubMainAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseGithubUrl.url!
    }

    var path: String {
        switch self {
        case .token: return "/login/oauth/access_token"
        }
    }

    var method: Moya.Method {
        .post
    }

    var headers: [String: String]? {
        [
            "Accept": "application/json"
        ]
    }

    var task: Task {
        var parameters = envParameters
        var encoding: ParameterEncoding = URLEncoding.default
        switch self {
        case let .token(code):
            parameters += [
                Parameter.clientId: Platform.github.appId,
                Parameter.clientSecret: Platform.github.appKey,
                Parameter.code: code
            ]
            encoding = URLEncoding.httpBody
        }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    var validationType: ValidationType { .none }

    var sampleData: Data { Data.init() }

}
