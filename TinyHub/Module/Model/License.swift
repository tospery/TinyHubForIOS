//
//  License.swift
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

struct License: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    var key: String?
    var name: String?
    var spdxId: String?
    var url: String?
    
    var nodeId: String {
        self.id
    }

    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id          <- map["node_id"]
        key         <- map["key"]
        name        <- map["name"]
        spdxId      <- map["spdx_id"]
        url         <- map["url"]
    }
    
}
