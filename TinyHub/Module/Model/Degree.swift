//
//  Degree.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/11.
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

struct Degree: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    
    static let `default` = Degree.init(id: "Followers")
    
    init() { }
    
    init(id: String) {
        self.id = id
    }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id          <- map["id"]
    }
    
}
