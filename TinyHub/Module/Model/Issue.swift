//
//  Issue.swift
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
import DateToolsSwift_Hi
import ReusableKit_Hi
import ObjectMapper_Hi

struct Issue: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var activeLockReason: String?
    var assignee: String?
    var assignees: [String]?
    var authorAssociation: String?
    var closedAt: String?
    var comments = 0
    var commentsUrl: String?
    var createdAt: String?
    var eventsUrl: String?
    var htmlUrl: String?
    var labelsUrl: String?
    var locked: Bool?
    var milestone: String?
    var nodeId: String?
    var number: Int?
    var performedViaGithubApp: String?
    var repositoryUrl: String?
    var state = State.open
    var updatedAt: String?
    var url: String?
    var user: User?
    var labels = [Label].init()
    var title: String?
    var body: String?
    
    var isValid: Bool {
        self.id != 0 && self.title?.isEmpty ?? true == false
    }
    
    var timeAgoSinceNow: String {
        guard let string = self.updatedAt else { return "" }
        guard let date = Date.init(iso8601: string) else { return "" }
        return date.timeAgoSinceNow
    }
    
    var createTime: String? {
        guard let string = self.createdAt else { return nil }
        guard let date = Date.init(iso8601: string) else { return nil }
        return date.string(withFormat: "yyyy-MM-dd HH:mm")
    }
    
    var closedTime: String? {
        guard let string = self.closedAt else { return nil }
        guard let date = Date.init(iso8601: string) else { return nil }
        return date.string(withFormat: "yyyy-MM-dd HH:mm")
    }
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id                      <- map["id"]
        activeLockReason        <- map["active_lock_reason"]
        assignee                <- map["assignee"]
        assignees               <- map["assignees"]
        authorAssociation       <- map["author_association"]
        body                    <- map["body"]
        closedAt                <- map["closed_at"]
        comments                <- map["comments"]
        commentsUrl             <- map["comments_url"]
        createdAt               <- map["created_at"]
        eventsUrl               <- map["events_url"]
        htmlUrl                 <- map["html_url"]
        labels                  <- map["labels"]
        labelsUrl               <- map["labels_url"]
        locked                  <- map["locked"]
        milestone               <- map["milestone"]
        nodeId                  <- map["node_id"]
        number                  <- map["number"]
        performedViaGithubApp   <- map["performed_via_github_app"]
        repositoryUrl           <- map["repository_url"]
        state                   <- map["state"]
        title                   <- map["title"]
        updatedAt               <- map["updated_at"]
        url                     <- map["url"]
        user                    <- map["user"]
    }
    
}
