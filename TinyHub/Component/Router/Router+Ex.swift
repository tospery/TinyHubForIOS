//
//  Router+Ex.swift
//  TinyHub
//
//  Created by liaoya on 2022/2/16.
//

import SwiftEntryKit
import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

extension Router.Host {
    static var trending: Router.Host { "trending" }
    static var event: Router.Host { "event" }
    static var favorite: Router.Host { "favorite" }
    static var about: Router.Host { "about" }
    static var repo: Router.Host { "repo" }
    static var issue: Router.Host { "issue" }
    static var feedback: Router.Host { "feedback" }
    static var modify: Router.Host { "modify" }
    static var page: Router.Host { "page" }
    static var dir: Router.Host { "dir" }
    static var file: Router.Host { "file" }
    static var branch: Router.Host { "branch" }
    static var pull: Router.Host { "pull" }
    static var urlscheme: Router.Host { "urlscheme" }
    static var theme: Router.Host { "theme" }
    static var localization: Router.Host { "localization" }
    static var test: Router.Host { "test" }
}

extension Router.Path {
    static var options: Router.Path { "options" }
    static var languages: Router.Path { "languages" }
    static var branches: Router.Path { "branches" }
    static var sinces: Router.Path { "sinces" }
}

extension Router: RouterCompatible {
    
    public func isLogined() -> Bool {
        User.current?.isValid ?? false
    }
    
    public func isLegalHost(host: Host) -> Bool {
        true
    }
    
    public func allowedPaths(host: Host) -> [Path] {
        switch host {
        case .popup: return [
            .branches, .sinces
        ]
        default: return []
        }
    }
    
    public func needLogin(host: Router.Host, path: Router.Path?) -> Bool {
        switch host {
        case .feedback: return true
        default: return false
        }
    }
    
    public func customLogin(
        _ provider: HiIOS.ProviderType,
        _ navigator: NavigatorProtocol,
        _ url: URLConvertible,
        _ values: [String: Any],
        _ context: Any?
    ) -> Bool {
        guard let top = UIViewController.topMost else { return false }
        if top.className.contains("LoginViewController") ||
            top.className.contains("TXSSOLoginViewController") {
            return false
        }
        var parameters = self.parameters(url, values, context) ?? [:]
        parameters[Parameter.transparetNavBar] = true
        let reactor = LoginViewReactor(provider, parameters)
        let controller = LoginViewController(navigator, reactor)
        let navigation = NavigationController(rootViewController: controller)
        top.present(navigation, animated: true)
        return true
    }

}
