//
//  URLSchemeListViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/27.
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

class URLSchemeListViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tapItem(sectionItem: SectionItem) {
        super.tapItem(sectionItem: sectionItem)
        switch sectionItem {
        case let .urlScheme(item):
            guard let urlScheme = item.model as? URLScheme  else { return }
            let pasteboard = UIPasteboard.general
            pasteboard.string = urlScheme.url
            self.navigator.toastMessage(R.string.localizable.toastCopyMessage(
                preferredLanguages: myLangs
            ))
        default:
            break
        }
    }
    
}
