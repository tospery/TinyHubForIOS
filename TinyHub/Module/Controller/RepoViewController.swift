//
//  RepoViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/24.
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

class RepoViewController: ListViewController {
    
    lazy var starButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isHidden = true
        button.titleLabel?.font = .bold(14)
        button.titleEdgeInsets = .init(top: -10, left: -20, bottom: 0, right: 0)
        button.imageEdgeInsets = .init(top: -10, left: -20, bottom: 0, right: 0)
        button.contentEdgeInsets = .init(top: 10, left: 20, bottom: 0, right: 0)
        button.setTitle(R.string.localizable.star(
            preferredLanguages: myLangs
        ), for: .normal)
        button.setTitle(R.string.localizable.unstar(
            preferredLanguages: myLangs
        ), for: .selected)
        button.theme.backgroundColor = themeService.attribute { $0.primaryColor }
        button.theme.titleColor(
            from: themeService.attribute { $0.backgroundColor },
            for: .normal
        )
        button.sizeToFit()
        button.layerCornerRadius = button.height / 2.f
        return button
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.addButtonToRight(button: self.starButton)
    }
    
    override func bind(reactor: GeneralViewReactor) {
        super.bind(reactor: reactor)
        self.starButton.rx.tap
            .map { Reactor.Action.execute(value: nil, active: true, needLogin: true) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        reactor.state.map { ($0.data as? RepoViewReactor.Data)?.isStarred }
            .distinctUntilChanged()
            .bind(to: self.rx.starring)
            .disposed(by: self.disposeBag)
    }
    
    override func handleLogin(isLogined: Bool?) {
    }

}

extension Reactive where Base: RepoViewController {

    var starring: Binder<Bool?> {
        return Binder(self.base) { viewController, isStarred in
            guard let isStarred = isStarred else { return }
            viewController.starButton.isHidden = false
            viewController.starButton.isSelected = isStarred
            viewController.navigationBar.setNeedsLayout()
            viewController.navigationBar.layoutIfNeeded()
        }
    }

}
