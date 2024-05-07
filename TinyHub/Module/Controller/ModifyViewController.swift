//
//  ModifyViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/8.
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

class ModifyViewController: ListViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showKeyboard()
        }
    }
    
    override func handleUser(user: UserType?) {
        super.handleUser(user: user)
        self.back(message: R.string.localizable.toastUpdateMessage(
            preferredLanguages: myLangs
        ))
    }
    
    func showKeyboard() {
        if let cell = self.collectionView.cellForItem(at: .init(item: 1, section: 0)) as? TextFieldCell {
            cell.textField.becomeFirstResponder()
        }
        if let cell = self.collectionView.cellForItem(at: .init(item: 1, section: 0)) as? TextViewCell {
            cell.textView.becomeFirstResponder()
        }
    }

}
