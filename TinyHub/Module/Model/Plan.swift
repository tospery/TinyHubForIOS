//
//  Plan.swift
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

struct Plan: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var space: Int?
    var privateRepos: Int?
    var collaborators: Int?
    var name: String?
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["id"]
        space           <- map["space"]
        privateRepos    <- map["private_repos"]
        collaborators   <- map["collaborators"]
        name            <- map["name"]
    }
    
}
