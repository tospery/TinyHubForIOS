//
//  Href.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/28.
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

struct Href: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var value: String?
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id          <- map["id"]
        value       <- map["href"]
    }
    
}
