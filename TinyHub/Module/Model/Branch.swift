//
//  Branch.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/14.
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

struct Branch: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    var `protected`: Bool?
    var commit: Commit?
    
    init() { }
    
    init(id: String) {
        self.id = id
    }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["name"]
        `protected`     <- map["protected"]
        commit          <- map["commit"]
    }
    
    var description: String { self.id }
    
}
