//
//  SettingViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/7.
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

class SettingViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tapItem(sectionItem: SectionItem) {
        super.tapItem(sectionItem: sectionItem)
        switch sectionItem {
        case let .simple(item):
            guard let simple = item.model as? Simple else { return }
            if let cellId = CellId.init(rawValue: simple.id) {
                switch cellId {
                case .cache:
                    guard let size = simple.detail, size != "0" else { return }
                    MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
                        guard let `self` = self else { fatalError() }
                        self.reactor?.action.onNext(.execute(value: nil, active: true, needLogin: false))
                        return Disposables.create {}
                    }.disposed(by: self.disposeBag)
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
//    override func handleLocalization(localization: Localization) {
//        super.handleLocalization(localization: localization)
//        MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
//            guard let `self` = self else { fatalError() }
//            self.reactor?.action.onNext(.reload)
//            return Disposables.create {}
//        }.disposed(by: self.disposeBag)
//    }

}
