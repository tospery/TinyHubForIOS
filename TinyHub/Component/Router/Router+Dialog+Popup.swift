//
//  Router+Dialog+Popup.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import UIKit
import Toast_Swift_Hi
import SwiftEntryKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import SwifterSwift
import AMPopTip
import HiIOS

extension Router {
    
    func popup(_ provider: HiIOS.ProviderType, _ navigator: NavigatorProtocol) {
        navigator.handle(self.urlPattern(host: .popup, placeholder: "[type:_]")) { url, values, context -> Bool in
            guard let popup = url.urlValue?.path.removingPrefix("/").removingSuffix("/") else { return false }
            let parameters = self.parameters(url, values, context)
            switch popup {
            case .branches: return self.popupBranches(provider, navigator, parameters)
            case .sinces: return self.popupSinces(provider, navigator, parameters)
            default: return false
            }
        }
    }
    
    func defaultPopupName() -> String {
        "Popup\(UInt64(round(Date.init().timeIntervalSince1970 * 1000)))"
    }
    
    // MARK: - Popup
    func popupBranches(
        _ provider: HiIOS.ProviderType,
        _ navigator: NavigatorProtocol,
        _ parameters: [String: Any]?
    ) -> Bool {
        let name = parameters?.string(for: Parameter.name) ?? self.defaultPopupName()
        var attributes = self.attributes(name)
        attributes.statusBar = .hidden
        attributes.roundCorners = .all(radius: 20)
        attributes.positionConstraints = .init(
            verticalOffset: 0,
            size: .init(width: .ratio(value: 0.74), height: .ratio(value: 0.36)),
            maxSize: .init(width: .ratio(value: 0.74), height: .ratio(value: 0.36))
        )
        
        let observer = parameters?[Parameter.routerObserver] as? AnyObserver<Any>
        guard let vc = navigator.viewController(
            for: Router.shared.urlString(host: .branch, path: .list),
            context: parameters
        ) as? BranchListViewController else { return false }
        vc.closeBlock = { value in
            SwiftEntryKit.dismiss(.specific(entryName: name)) {
                if value != nil {
                    observer?.onNext(value!)
                }
                observer?.onCompleted()
            }
        }
        let nc = NavigationController.init(rootViewController: vc)
        SwiftEntryKit.display(entry: nc, using: attributes)
        
        return true
    }

    func popupSinces(
        _ provider: HiIOS.ProviderType,
        _ navigator: NavigatorProtocol,
        _ parameters: [String: Any]?
    ) -> Bool {
        guard let string = parameters?.string(for: Parameter.frame) else { return false }
        guard let frame = CGRect.init(string: string) else { return false }
        let view = SinceView.init()
        view.index = parameters?.int(for: Parameter.selected) ?? 0
        view.sizeToFit()
        
        let popTip = PopTip.init()
        popTip.shouldShowMask = true
        popTip.cornerRadius = 8
        popTip.bubbleColor = .background
        popTip.sizeToFit()
        
        let observer = parameters?[Parameter.routerObserver] as? AnyObserver<Any>
        popTip.dismissHandler = { _ in
            var since = Since.daily
            if view.index == 1 {
                since = .weekly
            } else if view.index == 2 {
                since = .montly
            }
            observer?.onNext(since)
            observer?.onCompleted()
        }
        
        popTip.show(
            customView: view,
            direction: .auto,
            in: UIApplication.shared.window,
            from: frame
        )
        return true
    }
    
}
