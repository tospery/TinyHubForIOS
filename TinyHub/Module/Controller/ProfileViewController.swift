//
//  ProfileViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import ReusableKit_Hi
import ObjectMapper_Hi
import RxDataSources
import RxGesture
import HiIOS

class ProfileViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tapItem(sectionItem: SectionItem) {
        switch sectionItem {
        case let .simple(item):
            guard let simple = item.model as? Simple else { return }
            if simple.isButton {
                guard let target = simple.target, target.isNotEmpty else { return }
                self.navigator.rxJump(target)
                    .subscribe(onNext: { [weak self] result in
                        guard let `self` = self else { return }
                        guard let action = result as? SHAlertAction else { return }
                        if action == SHAlertAction.exit {
                            Subjection.update(AccessToken.self, nil)
                            User.update(nil, reactive: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.back()
                            }
                        }
                    }).disposed(by: self.disposeBag)
                return
            }
            guard
                let title = simple.title,
                let param = CellId.init(rawValue: simple.id)?.param
            else { return }
            self.navigator.jump(Router.shared.urlString(host: .modify, path: param, parameters: [
                Parameter.title: title,
                Parameter.value: item.currentState.detail ?? ""
            ]))
        default:
            super.tapItem(sectionItem: sectionItem)
        }
    }

}
