//
//  URLScheme.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/27.
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

struct URLScheme: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var name = ""
    var url = ""
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        url             <- map["url"]
    }
    
}
