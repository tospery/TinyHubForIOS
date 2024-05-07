//
//  AppEvent.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/13.
//

import Foundation
import Umbrella
import SwifterSwift
import HiIOS

let analytics = Analytics<AppEvent>()

enum AppEvent {
    case eventParseFail(name: String)
    case languageParseFail(name: String)
}

extension AppEvent: Umbrella.EventType {
    
    func name(for provider: Umbrella.ProviderType) -> String? {
        switch self {
        case .eventParseFail: return "event_parse_fail"
        case .languageParseFail: return "language_parse_fail"
        }
    }
    
    func parameters(for provider: Umbrella.ProviderType) -> [String: Any]? {
        var parameters = envParameters
        parameters += userParameters
        switch self {
        case let .eventParseFail(name),
            let .languageParseFail(name):
            parameters[Parameter.name] = name
        }
        return parameters
    }
    
}
