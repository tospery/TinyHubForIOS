//
//  TrendingAPI.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/30.
//

import Foundation
import Moya
import SwifterSwift
import HiIOS

enum TrendingAPI {
    case languages
    case trendingUsers(language: Language?, since: Since?)
    case trendingRepos(language: Language?, since: Since?)
}

extension TrendingAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseTrendingUrl.url!
    }

    var path: String {
        switch self {
        case .languages: return "/languages"
        case .trendingUsers: return "/developers"
        case .trendingRepos: return "/repositories"
        }
    }

    var method: Moya.Method { .get }

    var headers: [String: String]? { nil }

    var task: Task {
        var parameters = envParameters
        let encoding: ParameterEncoding = URLEncoding.default
        switch self {
        case .trendingUsers(let language, let since),
             .trendingRepos(let language, let since):
            parameters[Parameter.language] = language?.urlParam
            parameters[Parameter.since] = since?.rawValue
        default:
            break
        }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    var validationType: ValidationType { .none }

    var sampleData: Data { Data.init() }

}
