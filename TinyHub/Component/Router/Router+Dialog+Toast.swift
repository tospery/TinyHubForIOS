//
//  Router+Dialog+Toast.swift
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
import HiIOS

extension Router {
    
    func toast(_ provider: HiIOS.ProviderType, _ navigator: NavigatorProtocol) {
        navigator.handle(self.urlPattern(host: .toast)) { url, _, _ -> Bool in
            guard let window = AppDependency.shared.window else { return false }
            if let message = url.queryParameters[Parameter.message] {
                window.makeToast(message)
            } else if let active = url.queryParameters[Parameter.active] {
                window.isUserInteractionEnabled = !(active.bool ?? false)
                if active.bool ?? false {
                    window.makeToastActivity(.center)
                } else {
                    window.hideToastActivity()
                }
            } else {
                return false
            }
            return true
        }
    }

}
