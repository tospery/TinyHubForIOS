//
//  IssueListViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/9.
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

class IssueListViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
        self.shouldRefresh = reactor.parameters.bool(for: Parameter.shouldRefresh) ?? true
        self.shouldLoadMore = reactor.parameters.bool(for: Parameter.shouldLoadMore) ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.frame = .init(
            x: 0,
            y: 0,
            width: deviceWidth,
            height: deviceHeight - navigationContentTopConstant - TinyHub.Metric.menuHeight
        )
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
    
}
