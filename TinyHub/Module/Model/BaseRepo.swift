//
//  BaseRepo.swift
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

struct BaseRepo: Subjective, Eventable {
    
    enum Event {
    }

    var id = 0
    var url: String?
    var name: String?
    var desc: String?

    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id          <- map["id"]
        url         <- map["url"]
        name        <- map["name"]
        desc        <- map["description"]
    }

}
