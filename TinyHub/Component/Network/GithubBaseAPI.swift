//
//  GithubBaseAPI.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import Moya
import SwifterSwift
import HiIOS

enum GithubBaseAPI {
    // 整理后的
    // MARK: login
    case login(token: String)
    // MARK: user
    case user(username: String)
    case userEvents(username: String, page: Int)
    case userRepos(username: String, page: Int)
    case userStarred(username: String, page: Int)
    case userFollowers(username: String, page: Int)
    case userFollowing(username: String, page: Int)
    case userWatchs(username: String, page: Int)    // Subscriptions
    // MARK: repo
    case repo(username: String, reponame: String)
    case repoForks(username: String, reponame: String, page: Int)
    case repoStargazers(username: String, reponame: String, page: Int)
    case repoContributors(username: String, reponame: String, page: Int)
    case repoWatchers(username: String, reponame: String, page: Int)    // Subscribers
    // MARK: issue
    case issues(username: String, reponame: String, state: State, page: Int)
    // MARK: pull
    case pulls(username: String, reponame: String, state: State, page: Int)
    // MARK: branch
    case branches(username: String, reponame: String, page: Int)
    // MARK: contents
    case contents(username: String, reponame: String, subpath: String?, ref: String?)
    case readme(username: String, reponame: String, ref: String?)
    // MARK: star
    case checkStarring(username: String, reponame: String)
    case starRepo(username: String, reponame: String)
    case unstarRepo(username: String, reponame: String)
    // MARK: follow
    case checkFollowing(username: String)
    case followUser(username: String)
    case unfollowUser(username: String)
    // MARK: markdown
    case markdown(text: String)
    // MARK: search
    case searchRepos(keyword: String, language: Language?, order: SearchOrder, page: Int, sort: SearchSort)
    case searchUsers(keyword: String, degree: Degree?, order: SearchOrder, page: Int)
    // MARK: other
    case modify(key: String, value: String)
    case feedback(title: String, body: String)
}

extension GithubBaseAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseApiUrl.url!
    }

    var path: String {
        switch self {
        case .markdown: return "/markdown"
        case .login, .modify: return "/user"
        case .feedback: return "/repos/\(Author.username)/\(Author.reponame)/issues"
        case let .readme(username, reponame, _): return "/repos/\(username)/\(reponame)/readme"
        case .searchRepos: return "/search/repositories"
        case .searchUsers: return "/search/users"
        case .checkFollowing(let username),
                .followUser(let username),
                .unfollowUser(let username):
            return "/user/following/\(username)"
        case .checkStarring(let username, let reponame),
                .starRepo(let username, let reponame),
                .unstarRepo(let username, let reponame):
            return "/user/starred/\(username)/\(reponame)"
        case let .userEvents(username, _): return "/users/\(username)/received_events"
        case let .branches(username, reponame, _): return "/repos/\(username)/\(reponame)/branches"
        case let .user(username): return "/users/\(username)"
        case let .repo(username, reponame): return "/repos/\(username)/\(reponame)"
        case let .userRepos(username, _): return "/users/\(username)/repos"
        case let .userStarred(username, _): return "/users/\(username)/starred"
        case let .userFollowers(username, _): return "/users/\(username)/followers"
        case let .userFollowing(username, _): return "/users/\(username)/following"
        case let .userWatchs(username, _): return "/users/\(username)/subscriptions"
        case let .repoForks(username, reponame, _): return "/repos/\(username)/\(reponame)/forks"
        case let .repoStargazers(username, reponame, _): return "/repos/\(username)/\(reponame)/stargazers"
        case let .repoContributors(username, reponame, _): return "/repos/\(username)/\(reponame)/contributors"
        case let .repoWatchers(username, reponame, _): return "/repos/\(username)/\(reponame)/subscribers"
        case let .issues(username, reponame, _, _): return "/repos/\(username)/\(reponame)/issues"
        case let .pulls(username, reponame, _, _): return "/repos/\(username)/\(reponame)/pulls"
        case let .contents(username, reponame, subpath, _):
            return "/repos/\(username)/\(reponame)/contents/\(subpath ?? "")"
        }
    }

    var method: Moya.Method {
        switch self {
        case .feedback, .markdown: return .post
        case .followUser, .starRepo: return .put
        case .unfollowUser, .unstarRepo: return .delete
        case .modify: return .patch
        default: return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case let .login(token):
            return [Parameter.authorization: "token \(token)"]
        default:
            if let token = AccessToken.current?.accessToken {
                return [Parameter.authorization: "token \(token)"]
            }
            return nil
        }
    }

    var task: Task {
        var parameters = envParameters
        var encoding: ParameterEncoding = URLEncoding.default
        switch self {
        case let .modify(key, value):
            parameters[key] = value
            encoding = JSONEncoding.default
        case let .markdown(text):
            parameters[Parameter.text] = text
            encoding = JSONEncoding.default
        case let .feedback(title, body):
            parameters[Parameter.title] = title
            parameters[Parameter.body] = body
            encoding = JSONEncoding.default
        case let .readme(_, _, ref),
            let .contents(_, _, _, ref):
            parameters[Parameter.ref] = ref?.isNotEmpty ?? false ? ref : nil
        case .searchUsers(let keyword, let degree, let order, let page):
            parameters[Parameter.searchKey] = keyword
            parameters[Parameter.sort] = degree?.id.lowercased()
            parameters[Parameter.order] = order.rawValue
            parameters[Parameter.pageIndex] = page
            parameters[Parameter.pageSize] = UIApplication.shared.pageSize
        case .searchRepos(let keyword, let language, let order, let page, let sort):
            parameters[Parameter.searchKey] = keyword
            if let id = language?.id, id.isNotEmpty {
                parameters[Parameter.searchKey] = "\(keyword)+language:\(language?.name ?? "")"
            }
            parameters[Parameter.sort] = sort.rawValue
            parameters[Parameter.order] = order.rawValue
            parameters[Parameter.pageIndex] = page
            parameters[Parameter.pageSize] = UIApplication.shared.pageSize
        case let .userRepos(_, page),
            let .userStarred(_, page),
            let .userFollowers(_, page),
            let .userFollowing(_, page),
            let .userWatchs(_, page),
            let .userEvents(_, page):
            parameters[Parameter.pageIndex] = page
            parameters[Parameter.pageSize] = UIApplication.shared.pageSize
        case let .repoForks(_, _, page),
            let .repoStargazers(_, _, page),
            let .repoContributors(_, _, page),
            let .repoWatchers(_, _, page):
            parameters[Parameter.pageIndex] = page
            parameters[Parameter.pageSize] = UIApplication.shared.pageSize
        case let .branches(_, _, page):
            parameters[Parameter.pageIndex] = page
            parameters[Parameter.pageSize] = 200
        case let .issues(_, _, state, page),
            let .pulls(_, _, state, page):
            parameters[Parameter.state] = state.rawValue
            parameters[Parameter.pageIndex] = page
            parameters[Parameter.pageSize] = UIApplication.shared.pageSize
        default:
            return .requestPlain
        }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    var validationType: ValidationType { .none }

    var sampleData: Data {
        Data.init()
    }

}
