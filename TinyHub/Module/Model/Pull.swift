//
//  Pull.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/10.
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

struct Pull: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var reviewCommentUrl: String?
    var reviewComments: Int?
    var number: Int?
    var diffUrl: String?
    var requestedReviewers: [Int]?
    var maintainerCanModify: Bool?
    var requestedTeams: [Int]?
    var locked: Bool?
    var deletions: Int?
    var user: BaseUser?
    var nodeId: String?
    var htmlUrl: String?
    var commits: Int?
    var mergeCommitSha: String?
    var patchUrl: String?
    var authorAssociation: String?
    var draft: Bool?
    var changedFiles: Int?
    var statusesUrl: String?
    var url: String?
    var merged: Bool?
    var commitsUrl: String?
    var assignees: [Int]?
    var rebaseable: Bool?
    var mergeableState: String?
    var commentsUrl: String?
    var createdAt: String?
    var issueUrl: String?
    var mergeable: Bool?
    var reviewCommentsUrl: String?
    var body: String?
    var comments: Int?
    var additions: Int?
    var closedAt: String?
    var updatedAt: String?
    var title: String?
    var state = State.open
    var labels = [Label].init()
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id                      <- map["id"]
        reviewCommentUrl        <- map["review_comment_url"]
        reviewComments          <- map["review_comments"]
        number                  <- map["number"]
        diffUrl                 <- map["diff_url"]
        requestedReviewers      <- map["requested_reviewers"]
        maintainerCanModify     <- map["maintainer_can_modify"]
        requestedTeams          <- map["requested_teams"]
        locked                  <- map["locked"]
        deletions               <- map["deletions"]
        user                    <- map["user"]
        nodeId                  <- map["node_id"]
        htmlUrl                 <- map["html_url"]
        commits                 <- map["commits"]
        mergeCommitSha          <- map["merge_commit_sha"]
        patchUrl                <- map["patch_url"]
        authorAssociation       <- map["author_association"]
        draft                   <- map["draft"]
        changedFiles            <- map["changed_files"]
        statusesUrl             <- map["statuses_url"]
        url                     <- map["url"]
        merged                  <- map["merged"]
        commitsUrl              <- map["commits_url"]
        assignees               <- map["assignees"]
        rebaseable              <- map["rebaseable"]
        mergeableState          <- map["mergeable_state"]
        commentsUrl             <- map["comments_url"]
        createdAt               <- map["created_at"]
        issueUrl                <- map["issue_url"]
        mergeable               <- map["mergeable"]
        reviewCommentsUrl       <- map["review_comments_url"]
        body                    <- map["body"]
        comments                <- map["comments"]
        additions               <- map["additions"]
        closedAt                <- map["closed_at"]
        updatedAt               <- map["updated_at"]
        title                   <- map["title"]
        state                   <- map["state"]
        labels                  <- map["labels"]
    }
    
}
