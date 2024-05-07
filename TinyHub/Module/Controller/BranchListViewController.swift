//
//  BranchListViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/18.
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

class BranchListViewController: ListViewController {
    
    var closeBlock: ((Branch?) -> Void)?
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layerCornerRadius = 20
        self.navigationBar.style = .nosafe
        self.navigationBar.removeAllLeftButtons()
        self.navigationBar.removeAllRightButtons()
        self.navigationBar.addButtonToRight(image: UIImage.close).rx.tap
            .subscribeNext(weak: self, type(of: self).tapClose)
            .disposed(by: self.disposeBag)
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationBar.frame = .init(
            x: 0,
            y: 0,
            width: self.view.width,
            height: navigationBarHeight
        )
        self.collectionView.frame = .init(
            x: 0,
            y: self.navigationBar.bottom,
            width: self.view.width,
            height: self.view.height - self.navigationBar.bottom
        )
    }

    func tapClose(_: Void? = nil) {
        self.closeBlock?(nil)
    }
    
    override func tapItem(sectionItem: SectionItem) {
        super.tapItem(sectionItem: sectionItem)
        switch sectionItem {
        case let .branch(item):
            guard let branch = item.model as? Branch else { return }
            self.closeBlock?(branch)
        default:
            break
        }
    }
    
}
