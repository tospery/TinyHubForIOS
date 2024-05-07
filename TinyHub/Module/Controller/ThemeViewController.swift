//
//  ThemeViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/30.
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

class ThemeViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tapItem(sectionItem: SectionItem) {
        super.tapItem(sectionItem: sectionItem)
        switch sectionItem {
        case let .theme(item):
            guard let element = (item.model as? BaseModel)?.data as? SectionItemElement else { return }
            if case let .theme(colorTheme) = element {
                self.change(colorTheme)
            }
        default:
            break
        }
    }
    
    func change(_ colorTheme: ColorTheme) {
        guard self.reactor?.currentState.data as? ColorTheme != colorTheme else { return }
        self.navigator.rxAlert(
            R.string.localizable.prompt(
                preferredLanguages: myLangs
            ),
            R.string.localizable.alertThemeMessage(
                colorTheme.description,
                preferredLanguages: myLangs
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
            configuration?.theme = colorTheme
            Subjection.update(Configuration.self, configuration, true)
            ThemeType.current.change(
                primaryColor: colorTheme.primaryColor,
                secondaryColor: colorTheme.secondaryColor
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.back(message: R.string.localizable.toastThemeMessage(
                    preferredLanguages: myLangs
                ))
            }
        })
        .disposed(by: self.rx.disposeBag)
    }
    
}
