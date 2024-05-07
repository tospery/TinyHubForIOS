//
//  DataType.swift
//  TinyHub
//
//  Created by liaoya on 2022/7/21.
//

// swiftlint:disable file_length
import Foundation
import HiIOS

enum TabBarKey {
    case trending
    case event
    case favorite
    case personal
}

enum Page: String, Codable {
    case none
    // 趋势的
    case trendingRepos
    case trendingUsers
    // 问题的/合并请求的
    case open
    case closed
    // 用户的
    case repositories
    case followers
    case following
    case stars
    /// 订阅的仓库（subscriptions）
    case watchs
    // 仓库的
    /// 订阅的用户（subscribers）
    case watchers
    case stargazers
    case forks
    case contributors
    
    static let trendingValues = [trendingRepos, trendingUsers]
    static let userValues = [repositories, followers, following, stars, watchs]
    static let repoValues = [watchers, stargazers, forks, contributors]
    static let stateValues = [open, closed]
    
    var userStyle: User.Style? {
        switch self {
        case .trendingRepos: return .basic
        case .followers, .following: return .plain
        default: return nil
        }
    }
    
    var repoStyle: Repo.Style? {
        switch self {
        case .trendingRepos, .repositories, .stars, .watchs:
            return .basic
        default:
            return nil
        }
    }
    
    var state: State {
        switch self {
        case .open: return .open
        case .closed: return .closed
        default: return .open
        }
    }
    
    var title: String? {
        switch self {
        case .trendingRepos: return R.string.localizable.repositories(
            preferredLanguages: myLangs
        )
        case .trendingUsers: return R.string.localizable.developers(
            preferredLanguages: myLangs
        )
        case .repositories: return R.string.localizable.repositories(
            preferredLanguages: myLangs
        )
        case .followers: return R.string.localizable.followers(
            preferredLanguages: myLangs
        )
        case .following: return R.string.localizable.following(
            preferredLanguages: myLangs
        )
        case .stars: return R.string.localizable.stars(
            preferredLanguages: myLangs
        )
        case .watchs: return R.string.localizable.watchs(
            preferredLanguages: myLangs
        )
        case .watchers: return R.string.localizable.watchers(
            preferredLanguages: myLangs
        )
        case .stargazers: return R.string.localizable.stargazers(
            preferredLanguages: myLangs
        )
        case .forks: return R.string.localizable.forks(
            preferredLanguages: myLangs
        )
        case .contributors: return R.string.localizable.contributors(
            preferredLanguages: myLangs
        )
        case .open: return R.string.localizable.open(
            preferredLanguages: myLangs
        )
        case .closed: return R.string.localizable.closed(
            preferredLanguages: myLangs
        )
        default: return nil
        }
    }
    
    func apiPath(_ username: String, _ reponame: String) -> String {
        switch self {
        case .repositories:
            return "/users/\(username)/repos"
        case .stars:
            return "/users/\(username)/starred"
        case .followers:
            return "/users/\(username)/followers"
        case .following:
            return "/users/\(username)/following"
        case .watchs:
            return "/users/\(username)/subscriptions"
        case .forks:
            return "/repos/\(username)/\(reponame)/forks"
        case .watchers:
            return "/repos/\(username)/\(reponame)/subscribers"
        case .stargazers:
            return "/repos/\(username)/\(reponame)/stargazers"
        case .contributors:
            return "/repos/\(username)/\(reponame)/contributors"
        default:
            break
        }
        return ""
    }
    
}

enum SearchSort: String, Codable {
    case stars
    case forks
    case updated
    case issues  = "help-wanted-issues"
}

enum SearchOrder: String, Codable {
    case asc
    case desc
}

enum Platform {
    case github
    case umeng
    case weixin
    case qq
    
    var appId: String {
        switch self {
        case .github: return "your github appid"
        case .umeng: return "your umeng appid"
        case .weixin: return UIApplication.shared.urlScheme(name: "weixin") ?? ""
        case .qq: return "your qq appid"
        }
    }
    
    var appKey: String {
        switch self {
        case .github: return "your github appkey"
        case .umeng: return "your umeng appkey"
        case .weixin: return "your weixin appkey"
        case .qq: return "your qq apkey"
        }
    }
    
    var appLink: String {
        switch self {
        case .weixin: return "https://tospery.com/tinyhub/"
        case .qq: return "https://tinyhub.com/qq_conn/102039278"
        default: return ""
        }
    }

}

enum Since: String, Codable {
    case daily
    case weekly
    case montly
    
    static let name = R.string.localizable.since(
        preferredLanguages: myLangs
    )
    static let allValues = [daily, weekly, montly]
    
    var title: String {
        switch self {
        case .daily: return R.string.localizable.daily(preferredLanguages: myLangs)
        case .weekly: return R.string.localizable.weekly(preferredLanguages: myLangs)
        case .montly: return R.string.localizable.montly(preferredLanguages: myLangs)
        }
    }
}

enum State: String, Codable {
    case open
    case closed
    case all
    
    var icon: UIImage? {
        switch self {
        case .open: return R.image.ic_issue_open()
        case .closed: return R.image.ic_issue_closed()
        default: return nil
        }
    }
}

enum CellId: Int {
    case space          = 0, button
    case settings       = 10, about, feedback
    case company        = 20, location, email, blog, nickname, bio
    case author         = 30, qqgroup, schemes, score, share
    case language       = 40, issues, pulls, branches, readme
    case theme          = 50, localization, cache
    
    // static let settingsValues = [theme, localization, cache]
    
    var title: String? {
        switch self {
        case .company: return R.string.localizable.company(
            preferredLanguages: myLangs
        )
        case .location: return R.string.localizable.location(
            preferredLanguages: myLangs
        )
        case .blog: return R.string.localizable.blog(
            preferredLanguages: myLangs
        )
        case .nickname: return R.string.localizable.nickname(
            preferredLanguages: myLangs
        )
        case .bio: return R.string.localizable.bio(
            preferredLanguages: myLangs
        )
        case .issues: return R.string.localizable.issues(
            preferredLanguages: myLangs
        )
        case .pulls: return R.string.localizable.pulls(
            preferredLanguages: myLangs
        )
        case .branches: return R.string.localizable.branches(
            preferredLanguages: myLangs
        )
        case .readme: return R.string.localizable.readme(
            preferredLanguages: myLangs
        ).uppercased()
        case .settings: return R.string.localizable.settings(
            preferredLanguages: myLangs
        )
        case .theme: return R.string.localizable.theme(
            preferredLanguages: myLangs
        )
        case .localization: return R.string.localizable.language(
            preferredLanguages: myLangs
        )
        case .cache: return R.string.localizable.clearCache(
            preferredLanguages: myLangs
        )
        case .about: return R.string.localizable.about(
            preferredLanguages: myLangs
        )
        case .feedback: return R.string.localizable.feedback(
            preferredLanguages: myLangs
        )
            
        case .author: return R.string.localizable.author(
            preferredLanguages: myLangs
        )
        case .qqgroup: return R.string.localizable.qqGroup(
            preferredLanguages: myLangs
        )
        case .schemes: return R.string.localizable.urlSchemes(
            preferredLanguages: myLangs
        )
        case .score: return R.string.localizable.score(
            preferredLanguages: myLangs
        )
        case .share: return R.string.localizable.share(
            preferredLanguages: myLangs
        )
        default: return nil
        }
    }
    
    var param: String? {
        switch self {
        case .company: return Parameter.company
        case .location: return Parameter.location
        case .blog: return Parameter.blog
        case .nickname: return Parameter.name
        case .bio: return Parameter.bio
        default: return nil
        }
    }
    
    var icon: String? {
        switch self {
        // user
        case .company: return R.image.ic_company.name
        case .location: return R.image.ic_location.name
        case .email: return R.image.ic_email.name
        case .blog: return R.image.ic_blog.name
        // personal
        case .settings: return R.image.ic_settings.name
        case .about: return R.image.ic_about.name
        case .feedback: return R.image.ic_feedback.name
        // repo
        case .language: return R.image.ic_language.name
        case .issues: return R.image.ic_issues.name
        case .pulls: return R.image.ic_pulls.name
        case .branches: return R.image.ic_branches.name
        case .readme: return R.image.ic_readme.name
        default: return nil
        }
    }
    
    var target: String? {
        switch self {
        case .nickname: return Router.shared.urlString(host: .modify, path: Parameter.nickname)
        case .bio: return Router.shared.urlString(host: .modify, path: Parameter.bio)
        case .company: return Router.shared.urlString(host: .modify, path: Parameter.company)
        case .location: return Router.shared.urlString(host: .modify, path: Parameter.location)
        case .blog: return Router.shared.urlString(host: .modify, path: Parameter.blog)
        case .settings: return Router.shared.urlString(host: .settings)
        case .about: return Router.shared.urlString(host: .about)
        case .feedback: return Router.shared.urlString(host: .feedback)
        case .schemes: return Router.shared.urlString(host: .urlscheme, path: .list)
        case .author: return "\(UIApplication.shared.baseWebUrl)/\(Author.username)"
        default: return nil
        }
    }
    
}

enum SHAlertAction: AlertActionType, Equatable {
    case destructive
    case `default`
    case cancel
    case input
    case onlyPublic
    case withPrivate
    case exit
    
    init?(string: String) {
        switch string {
        case SHAlertAction.cancel.title: self = SHAlertAction.cancel
        case SHAlertAction.exit.title: self = SHAlertAction.exit
        default: return nil
        }
    }

    var title: String? {
        switch self {
        case .destructive:  return R.string.localizable.sure(
            preferredLanguages: myLangs
        )
        case .default:  return R.string.localizable.oK(
            preferredLanguages: myLangs
        )
        case .cancel: return R.string.localizable.cancel(
            preferredLanguages: myLangs
        )
        case .onlyPublic: return R.string.localizable.loginPrivilegeOnlyPublic(
            preferredLanguages: myLangs
        )
        case .withPrivate: return R.string.localizable.loginPrivilegeWithPrivate(
            preferredLanguages: myLangs
        )
        case .exit: return R.string.localizable.exit(
            preferredLanguages: myLangs
        )
        default: return nil
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .cancel:  return .cancel
        case .destructive, .exit:  return .destructive
        default: return .default
        }
    }

    static func == (lhs: SHAlertAction, rhs: SHAlertAction) -> Bool {
        switch (lhs, rhs) {
        case (.destructive, .destructive),
            (.default, .default),
            (.cancel, .cancel),
            (.input, .input),
            (.onlyPublic, .onlyPublic),
            (.withPrivate, .withPrivate),
            (.exit, .exit):
            return true
        default:
            return false
        }
    }
}

struct Author {
    static let username = "tospery"
    static let reponame = "HiIOS"
}

struct Metric {
    
    static let menuHeight   = 44.f
    
    struct Personal {
        static let parallaxTopHeight    = 244.0
        static let parallaxAllHeight    = 290.0
    }
    
    struct BasicCell {
        static let height = 114.f
        static let forksWidth = 55.f
        static let avatarSize = CGSize.init(44.f)
        static let margin = UIEdgeInsets.init(top: 10, left: 10, bottom: 5, right: 5)
        static let padding = UIOffset.init(horizontal: 10, vertical: 8)
    }
    
    struct DetailCell {
        static let maxLines = 5
        static let avatarSize = CGSize.init(60.f)
        static let margin = UIEdgeInsets.init(top: 10, left: 15, bottom: 5, right: 5)
        static let padding = UIOffset.init(horizontal: 10, vertical: 8)
    }
    
}
// swiftlint:enable file_length
