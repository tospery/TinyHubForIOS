//
//  BaseUser.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi

struct BaseUser: Subjective, Eventable {

    enum Event {
    }

    var id = 0
    var username: String?
    var avatar: String?
    var url: String?

    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["id"]
        username        <- map["username|login|display_login", nested: false, delimiter: "|"]
        avatar          <- map["avatar|avatar_url", nested: false, delimiter: "|"]
        url             <- map["url|href", nested: false, delimiter: "|"]
    }

}
