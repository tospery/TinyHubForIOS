//
//  SearchViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/18.
//

import UIKit
import QMUIKit
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

class SearchViewController: ListViewController {
    
    lazy var searchView: SearchView = {
        let view = SearchView.init(frame: .zero)
        view.textField.isEnabled = false
        view.sizeToFit()
        return view
    }()
    
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
        self.navigationBar.addButtonToRight(title: R.string.localizable.cancel(
            preferredLanguages: myLangs
        )).rx.tap
            .subscribeNext(weak: self, type(of: self).tapBack)
            .disposed(by: self.disposeBag)
        self.navigationBar.titleView = self.searchView
        self.navigationBar.theme.rightItemColor = themeService.attribute { $0.primaryColor }
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
    
    override func back(
        type: BackType? = nil, animated: Bool = true,
        result: Any? = nil, cancel: Bool = false, message: String? = nil
    ) {
        super.back(type: type, animated: false, result: result, cancel: cancel, message: message)
    }
    
    override func bind(reactor: GeneralViewReactor) {
        super.bind(reactor: reactor)
        self.searchView.rx.click
            .mapTo(
                Router.shared.urlString(
                    host: .search,
                    path: .history,
                    parameters: [Parameter.animated: false.string]
                )
            )
            .map(Reactor.Action.target)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.data as? String }
            .distinctUntilChanged()
            .bind(to: self.searchView.textField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    override func shouldPopViewController(byBackButtonOrPopGesture byPopGesture: Bool) -> Bool {
        if byPopGesture {
            return false
        }
        return true
    }

}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, keyword.isNotEmpty {
            return true
        }
        return false
    }

}
