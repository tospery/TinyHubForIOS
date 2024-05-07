//
//  Link.swift
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

struct Link: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    var git: String?
    var html: String?
    var myself: String?
    var comments: Href?
    var commits: Href?
    var issue: Href?
    var reviewComment: Href?
    var reviewComments: Href?
    var statuses: Href?
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id                  <- map["id"]
        git                 <- map["git"]
        html                <- map["html"]
        myself              <- map["self"]
        comments            <- map["comments"]
        commits             <- map["commits"]
        issue               <- map["issue"]
        reviewComment       <- map["review_comment"]
        reviewComments      <- map["review_comments"]
        statuses            <- map["statuses"]
    }
    
}
