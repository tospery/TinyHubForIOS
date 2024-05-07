//
//  Label.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/6.
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

struct Label: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var color: String?
    var `default`: Bool?
    var desc: String?
    var name: String?
    var nodeId: String?
    var url: String?
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id                  <- map["id"]
        color               <- map["color"]
        `default`           <- map["default"]
        desc                <- map["description"]
        name                <- map["name"]
        nodeId              <- map["node_id"]
        url                 <- map["url"]
    }
    
}
