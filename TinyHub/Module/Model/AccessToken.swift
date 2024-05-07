//
//  AccessToken.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import Rswift
import ObjectMapper_Hi
import HiIOS

struct AccessToken: Subjective {

    var id = 0
    var accessToken: String?
    var tokenType: String?
    var scope: String?

    init() { }
    
    init(accessToken: String?) {
        self.accessToken = accessToken
    }

    init?(map: Map) { }
    
    var isValid: Bool {
        accessToken?.isNotEmpty ?? false && tokenType?.isNotEmpty ?? false
    }

    mutating func mapping(map: Map) {
        id              <- map["id"]
        accessToken     <- map["access_token"]
        tokenType       <- map["token_type"]
        scope           <- map["scope"]
    }

}
