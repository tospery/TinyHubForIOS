//
//  MyRouter+Page.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import Foundation
import HiIOS
import URLNavigator_Hi

extension Router {
    
    // swiftlint:disable function_body_length
    public func page(_ provider: HiIOS.ProviderType, _ navigator: NavigatorProtocol) {
//        let normalFactory: ViewControllerFactory = { url, values, context in
//            guard let parameters = self.parameters(url, values, context) else { return nil }
//            return ListViewController(navigator, ListViewReactor.init(provider, parameters))
//        }
//        navigator.register(self.urlPattern(host: .about), normalFactory)
        navigator.register(self.urlPattern(host: .trending)) { url, values, context in
            TrendingViewController(navigator, TrendingViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .event)) { url, values, context in
            EventViewController(navigator, EventViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .favorite)) { url, values, context in
            FavoriteViewController(navigator, FavoriteViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .personal)) { url, values, context in
            PersonalViewController(navigator, PersonalViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .settings)) { url, values, context in
            SettingViewController(navigator, SettingViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .about)) { url, values, context in
            AboutViewController(navigator, AboutViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .profile)) { url, values, context in
            ProfileViewController(navigator, ProfileViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://user/list?page=&username=&reponame=
        navigator.register(self.urlPattern(host: .user, path: .list)) { url, values, context in
            UserListViewController(navigator, UserListViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://repo/list?page=&username=&reponame=
        navigator.register(self.urlPattern(host: .repo, path: .list)) { url, values, context in
            RepoListViewController(navigator, RepoListViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://issue/list?page=&username=&reponame=
        navigator.register(self.urlPattern(host: .issue, path: .list)) { url, values, context in
            IssueListViewController(navigator, IssueListViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://pull/list?page=&username=&reponame=
        navigator.register(self.urlPattern(host: .pull, path: .list)) { url, values, context in
            PullListViewController(navigator, PullListViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://page?pages=&username=&reponame=
        navigator.register(self.urlPattern(host: .page)) { url, values, context in
            PageViewController(navigator, PageViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .search, path: .history)) { url, values, context in
            SearchHistoryViewController(
                navigator,
                SearchHistoryViewReactor(provider, self.parameters(url, values, context))
            )
        }
        navigator.register(self.urlPattern(host: .search, path: .options)) { url, values, context in
            OptionsViewController(
                navigator,
                OptionsViewReactor(provider, self.parameters(url, values, context))
            )
        }
        navigator.register(self.urlPattern(host: .search)) { url, values, context in
            SearchViewController(navigator, SearchViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://trending/languages
        navigator.register(self.urlPattern(host: .trending, path: .languages)) { url, values, context in
            OptionsViewController(navigator, OptionsViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://user/<username>
        navigator.register(self.urlPattern(host: .user, placeholder: "[username]")) { url, values, context in
            UserViewController(navigator, UserViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://repo/<username>/<reponame>
        navigator.register(self.urlPattern(host: .repo, placeholder: "[username]/[reponame]")) { url, values, context in
            RepoViewController(navigator, RepoViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .feedback)) { url, values, context in
            FeedbackViewController(navigator, FeedbackViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .modify, placeholder: "[\(Parameter.key)]")) { url, values, context in
            ModifyViewController(navigator, ModifyViewReactor(provider, self.parameters(url, values, context)))
        }
        // tinyhub://dir?url=
        navigator.register(self.urlPattern(host: .dir)) { url, values, context in
            DirViewController(
                navigator,
                DirViewReactor(provider, self.parameters(url, values, context))
            )
        }
        // tinyhub://file?url=
        navigator.register(self.urlPattern(host: .file)) { url, values, context in
            FileViewController(navigator, FileViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .branch, path: .list)) { url, values, context in
            BranchListViewController(navigator, BranchListViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .urlscheme, path: .list)) { url, values, context in
            URLSchemeListViewController(
                navigator,
                URLSchemeListViewReactor(provider, self.parameters(url, values, context))
            )
        }
        navigator.register(self.urlPattern(host: .theme)) { url, values, context in
            ThemeViewController(
                navigator,
                ThemeViewReactor(provider, self.parameters(url, values, context))
            )
        }
        navigator.register(self.urlPattern(host: .localization)) { url, values, context in
            LocalizationViewController(
                navigator,
                LocalizationViewReactor(provider, self.parameters(url, values, context))
            )
        }
        navigator.register(self.urlPattern(host: .test)) { url, values, context in
            TestViewController(navigator, TestViewReactor(provider, self.parameters(url, values, context)))
        }
    }
    // swiftlint:enable function_body_length
    
}
