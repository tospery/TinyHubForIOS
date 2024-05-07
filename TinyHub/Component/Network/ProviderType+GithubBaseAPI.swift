//
//  ProviderType+GithubBaseAPI.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import HiIOS

extension ProviderType {
    
    // MARK: 登录/注册
    /// 用户登录
    func login(token: String) -> Single<User> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.login(token: token)
            ),
            type: User.self
        )
    }

    // MARK: 用户相关
    func userRepos(username: String, page: Int) -> Single<[Repo]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.userRepos(username: username, page: page)
            ),
            type: Repo.self
        )
    }
    
    func userStarred(username: String, page: Int) -> Single<[Repo]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.userStarred(username: username, page: page)
            ),
            type: Repo.self
        )
    }
    
    func userWatchs(username: String, page: Int) -> Single<[Repo]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.userWatchs(username: username, page: page)
            ),
            type: Repo.self
        )
    }
    
    func userFollowers(username: String, page: Int) -> Single<[User]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.userFollowers(username: username, page: page)
            ),
            type: User.self
        )
    }
    
    func userFollowing(username: String, page: Int) -> Single<[User]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.userFollowing(username: username, page: page)
            ),
            type: User.self
        )
    }
    
    // MARK: 其他
    /// 用户信息
    /// - API: https://docs.github.com/en/rest/reference/users#get-a-user
    /// - Demo: https://api.github.com/users/ReactiveX
    func user(username: String) -> Single<User> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.user(username: username)
            ),
            type: User.self
        )
    }
    
    /// https://api.github.com/repos/ReactiveX/RxSwift
    func repo(username: String, reponame: String) -> Single<Repo> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.repo(username: username, reponame: reponame)
            ),
            type: Repo.self
        )
    }
    
    func readme(username: String, reponame: String, ref: String?) -> Single<Content> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.readme(username: username, reponame: reponame, ref: ref)
            ),
            type: Content.self
        )
    }
    
    func contents(username: String, reponame: String, subpath: String?, ref: String?) -> Single<[Content]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.contents(username: username, reponame: reponame, subpath: subpath, ref: ref)
            ),
            type: Content.self
        )
    }
    
    func searchRepos(
        keyword: String,
        language: Language? = nil,
        order: SearchOrder = .desc,
        page: Int,
        sort: SearchSort = .stars
    ) -> Single<[Repo]> {
        networking.requestList(
            MultiTarget.init(
                GithubBaseAPI.searchRepos(keyword: keyword, language: language, order: order, page: page, sort: sort)
            ),
            type: Repo.self
        ).map { $0.items }
    }
    
    /// 搜索开发者
    /// - API: https://docs.github.com/v3/search
    /// - Demo: https://api.github.com/search/users?order=desc&page=1&q=rxswift&sort=followers
    func searchUsers(
        keyword: String,
        degree: Degree? = nil,
        order: SearchOrder = .desc,
        page: Int)
    -> Single<[User]> {
        networking.requestList(
            MultiTarget.init(
                GithubBaseAPI.searchUsers(keyword: keyword, degree: degree, order: order, page: page)
            ),
            type: User.self
        ).map { $0.items }
    }
    
    func followUser(username: String) -> Single<Void> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.followUser(username: username)
            )
        ).mapTo(())
    }

    func unfollowUser(username: String) -> Single<Void> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.unfollowUser(username: username)
            )
        ).mapTo(())
    }
    
    func checkFollowing(username: String) -> Single<Bool> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.checkFollowing(username: username)
            )
        )
        .mapTo(true)
    }

    func feedback(title: String, body: String) -> Single<Issue> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.feedback(title: title, body: body)
            ),
            type: Issue.self
        )
    }
    
    /// 用户事件
    func userEvents(username: String, page: Int) -> Single<[Event]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.userEvents(username: username, page: page)
            ),
            type: Event.self
        )
    }
    
    /// 修改用户信息
    /// - API: https://docs.github.com/en/rest/reference/users#update-the-authenticated-user
    /// - Demo: https://api.github.com/user
    func modify(key: String, value: String) -> Single<User> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.modify(key: key, value: value)
            ),
            type: User.self
        )
    }
    
    /// 分支列表
    /// - API: https://docs.github.com/en/rest/reference/repos#list-branches
    /// - Demo: https://api.github.com/repos/ReactiveX/RxSwift/branches?page=1
    func branches(username: String, reponame: String, page: Int) -> Single<[Branch]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.branches(username: username, reponame: reponame, page: page)
            ),
            type: Branch.self
        )
    }
    
    func repoWatchers(username: String, reponame: String, page: Int) -> Single<[User]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.repoWatchers(username: username, reponame: reponame, page: page)
            ),
            type: User.self
        )
    }
    
    func repoStargazers(username: String, reponame: String, page: Int) -> Single<[User]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.repoStargazers(username: username, reponame: reponame, page: page)
            ),
            type: User.self
        )
    }
    
    func repoForks(username: String, reponame: String, page: Int) -> Single<[Repo]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.repoForks(username: username, reponame: reponame, page: page)
            ),
            type: Repo.self
        )
    }
    
    func repoContributors(username: String, reponame: String, page: Int) -> Single<[User]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.repoContributors(username: username, reponame: reponame, page: page)
            ),
            type: User.self
        )
    }
    
    func checkStarring(username: String, reponame: String) -> Single<Bool> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.checkStarring(username: username, reponame: reponame)
            )
        ).mapTo(true)
    }
    
    func starRepo(username: String, reponame: String) -> Single<Void> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.starRepo(username: username, reponame: reponame)
            )
        ).mapTo(())
    }
    
    func unstarRepo(username: String, reponame: String) -> Single<Void> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.unstarRepo(username: username, reponame: reponame)
            )
        ).mapTo(())
    }
    
    func issues(username: String, reponame: String, state: State, page: Int) -> Single<[Issue]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.issues(username: username, reponame: reponame, state: state, page: page)
            ),
            type: Issue.self
        )
    }
    
    func pulls(username: String, reponame: String, state: State, page: Int) -> Single<[Pull]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.pulls(username: username, reponame: reponame, state: state, page: page)
            ),
            type: Pull.self
        )
    }
    
    func markdown(text: String) -> Single<String> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.markdown(text: text)
            )
        ).mapString()
    }
    
}
