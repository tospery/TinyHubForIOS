//
//  OptionsViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2024/3/23.
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
import BonMot
import HiIOS

class OptionsViewController: ListViewController {
    
    lazy var titleView: UISegmentedControl = {
        let view = UISegmentedControl.init(items: [
            R.string.localizable.repositories(
                preferredLanguages: myLangs
            ),
            R.string.localizable.users(
                preferredLanguages: myLangs
            )
        ])
        view.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.normal(14),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .selected)
        view.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.normal(14),
            NSAttributedString.Key.foregroundColor: UIColor.title
        ], for: .normal)
        view.sizeToFit()
        return view
    }()
    
    lazy var searchView: SearchView = {
        let view = SearchView.init()
        view.margin = 15
        view.textField.returnKeyType = .done
        view.textField.attributedPlaceholder = .composed(of: [
            R.image.ic_search()!.styled(with: .baselineOffset(-1)),
            Special.space,
            R.string.localizable.searchHintItem(
                preferredLanguages: myLangs
            ).styled(with: .baselineOffset(2))
        ]).styled(with: .color(.footer), .font(.normal(14)))
        view.sizeToFit()
        view.height = 50
        return view
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.reactor?.host == .search {
            self.navigationBar.titleView = self.titleView
        }
        self.view.addSubview(self.searchView)
        self.searchView.left = 0
        self.searchView.top = navigationContentTopConstant
        self.collectionView.top = self.searchView.bottom
        self.collectionView.height -= self.searchView.height
        self.navigationBar.theme.rightItemColor = themeService.attribute { $0.primaryColor }
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
    
    override func bind(reactor: GeneralViewReactor) {
        super.bind(reactor: reactor)
        self.searchView.rx.text
            .distinctUntilChanged()
            .skip(1)
            .map { Reactor.Action.execute(value: $0, active: false, needLogin: false) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        if self.reactor?.host == .search {
            self.rx.select
                .distinctUntilChanged()
                .ignore(-1)
                .map { index -> OptionsViewReactor.Data? in
                    var data = reactor.currentState.data as? OptionsViewReactor.Data
                    data?.index = index
                    return data
                }
                .map(Reactor.Action.data)
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
            reactor.state.map { ($0.data as? OptionsViewReactor.Data)?.index }
                .distinctUntilChanged()
                .bind(to: self.rx.index)
                .disposed(by: self.disposeBag)
        }
    }

}

extension Reactive where Base: OptionsViewController {
    
    var select: ControlProperty<Int> {
        self.base.titleView.rx.selectedSegmentIndex
    }
    
    var index: Binder<Int?> {
        return Binder(self.base) { viewController, index in
            viewController.titleView.selectedSegmentIndex = index ?? 0
            viewController.searchView.textField.text = nil
            viewController.searchView.textField.resignFirstResponder()
            guard viewController.isViewLoaded else { return }
            MainScheduler.asyncInstance.schedule(()) { [weak viewController] _ -> Disposable in
                guard let strongVC = viewController else { fatalError() }
                strongVC.reactor?.action.onNext(.reload)
                return Disposables.create {}
            }.disposed(by: viewController.disposeBag)
        }
    }

}
