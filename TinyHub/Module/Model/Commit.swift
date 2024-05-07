//
//  Commit.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/7.
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

struct Commit: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    var author: User?
    var message: String?
    var distinct: Bool?
    var url: String?
    
    var sha: String { self.id }
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["sha"]
        author          <- map["author"]
        message         <- map["message"]
        distinct        <- map["distinct"]
        url             <- map["url"]
    }
    
}
