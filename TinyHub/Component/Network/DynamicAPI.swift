//
//  DynamicAPI.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/19.
//

import Foundation
import Moya
import SwifterSwift
import Alamofire
import HiIOS

enum DynamicAPI {
    case request(path: String, parameters: [String: String]?)
}

extension DynamicAPI: TargetType {
    
    var baseURL: URL { fatalError() }

    var path: String {
        switch self {
        case let .request(path, _): return path
        }
    }

    var method: Moya.Method { .get }

    var headers: [String: String]? {
        if let token = AccessToken.current?.accessToken {
            return [Parameter.authorization: "token \(token)"]
        }
        return nil
    }

    var task: Task {
        switch self {
        case let .request(_, parameters):
            return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
        }
    }

    var validationType: ValidationType { .none }

    var sampleData: Data { .init() }

}
