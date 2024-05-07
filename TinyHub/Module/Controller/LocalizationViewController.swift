//
//  LocalizationViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/29.
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

class LocalizationViewController: ListViewController {
    
    lazy var testLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = .red
        label.font = .normal(16)
        label.sizeToFit()
        label.width = deviceWidth
        label.height = 30
        return label
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.testLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.testLabel.left = self.testLabel.leftWhenCenter
        self.testLabel.top = self.testLabel.topWhenCenter
    }
    
    override func tapItem(sectionItem: SectionItem) {
        super.tapItem(sectionItem: sectionItem)
        switch sectionItem {
        case let .check(item):
            guard let element = (item.model as? BaseModel)?.data as? SectionItemElement else { return }
            if case let .check(name) = element {
                self.change(name as? Localization ?? .system)
            }
        default:
            break
        }
    }
    
    func change(_ localization: Localization) {
        guard self.reactor?.currentState.data as? Localization != localization else { return }
        self.navigator.rxAlert(
            R.string.localizable.prompt(
                preferredLanguages: myLangs
            ),
            R.string.localizable.alertLocalizationMessage(
                localization.description, preferredLanguages: myLangs
            ),
            [
                SHAlertAction.cancel,
                SHAlertAction.destructive
            ]
        )
        .subscribe(onNext: { [weak self] action in
            guard let `self` = self else { return }
            guard let action = action as? SHAlertAction, action == .destructive else { return }
            var configuration = self.reactor?.currentState.configuration as? Configuration
            configuration?.localization = localization
            Subjection.update(Configuration.self, configuration, true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.back(message: R.string.localizable.toastLocalizationMessage(
                    preferredLanguages: myLangs
                ))
            }
        })
        .disposed(by: self.rx.disposeBag)
    }
    
}
