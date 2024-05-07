//
//  Payload.swift
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

struct Payload: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var pushId: Int?
    var size: Int?
    var distinctSize: Int?
    var ref: String?
    var head: String?
    var before: String?
    var action: String?
    var issue: Issue?
    var forkee: Repo?
    var pull: Pull?
    var commits: [Commit]?
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["id"]
        pushId          <- map["push_id"]
        size            <- map["size"]
        distinctSize    <- map["distinct_size"]
        ref             <- map["ref"]
        head            <- map["head"]
        before          <- map["before"]
        action          <- map["action"]
        issue           <- map["issue"]
        forkee          <- map["forkee"]
        pull            <- map["pull_request"]
        commits         <- map["commits"]
    }
    
}
