//
//  AppDependency.swift
//  TinyHub
//
//  Created by liaoya on 2022/7/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS
import RxOptional
import RxSwiftExt
import NSObject_Rx
import RxDataSources
import RxViewController
import RxTheme
import ReusableKit_Hi
import ObjectMapper_Hi
import SwifterSwift
import BonMot


final class AppDependency: HiIOS.AppDependency {

    static var shared = AppDependency()
    
    // MARK: - Initialize
    override func initialScreen(with window: inout UIWindow?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        self.window = window

        let reactor = TabBarReactor(self.provider, nil)
        let controller = TabBarController(self.navigator, reactor)
        self.window.rootViewController = controller
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Test
    override func test(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        log("环境参数: \(envParameters)", module: .common)
        log("accessToken = \(AccessToken.current?.accessToken ?? "")")
        // NSString *language = [NSLocale preferredLanguages][0];
//        let langs = Locale.preferredLanguages
//        log("看看语言: \(langs)")
//        let aaa = "[\"Exit\",\"Cancel\"]"
//        let bbb = aaa.data(using: .utf8)
//        let ccc = try? bbb?.jsonObject()
//        let ddd = ccc as? [String]
        log("用户参数: \(userParameters)", module: .common)
    }

    // MARK: - Setup
    override func setupConfiguration() {
        
    }
    
    // MARK: - Lifecycle
    override func application(
        _ application: UIApplication,
        entryDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        super.application(application, entryDidFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(
        _ application: UIApplication,
        leaveDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        super.application(application, leaveDidFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - URL
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
//        let result = UMSocialManager.default().handleOpen(url, options: options)
//        if !result {
//            // 其他SDK，如支付
//        }
//        return result
        super.application(app, open: url, options: options)
    }
    
    // MARK: - userActivity
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
//        let result = UMSocialManager.default().handleUniversalLink(userActivity, options: nil)
//        if !result {
//            // 其他SDK，如支付
//        }
//        return result
        super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
}
