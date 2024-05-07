//
//  FeedbackViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/6.
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

class FeedbackViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func tapLink(link: String) {
//        self.navigator.forward(
//            Router.shared.urlString(host: .page, parameters: [
//                Parameter.username: Author.username,
//                Parameter.reponame: Author.reponame,
//                Parameter.title: R.string.localizable.issues(),
//                Parameter.pages: Page.stateValues.map { $0.rawValue }.jsonString() ?? ""
//            ])
//        )
//    }
    
}
