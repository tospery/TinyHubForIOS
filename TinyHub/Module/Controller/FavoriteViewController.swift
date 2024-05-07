//
//  FavoriteViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/29.
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

class FavoriteViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
        self.shouldRefresh = reactor.parameters.bool(for: Parameter.shouldRefresh) ?? true
        self.shouldLoadMore = reactor.parameters.bool(for: Parameter.shouldLoadMore) ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleContents(contents: [HiContent]) {
        guard let host = self.reactor?.host, host.isNotEmpty else { return }
        guard let index = self.reactor?.pageIndex, index == self.reactor?.pageStart else { return }
        guard let repos = contents.first?.models as? [Repo], repos.isNotEmpty else { return }
        let first = [Repo].init(repos.prefix(self.reactor?.pageSize ?? UIApplication.shared.pageSize))
        Repo.storeArray(first, page: host)
        log("repo缓存->\(host)【首页.收藏】")
    }

}
