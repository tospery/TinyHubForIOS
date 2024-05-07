//
//  SearchHistoryViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/3.
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

class SearchHistoryViewController: ListViewController {
    
    lazy var searchView: SearchView = {
        let view = SearchView.init(frame: .zero)
        view.textField.delegate = self
        view.sizeToFit()
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
        self.navigationBar.removeAllLeftButtons()
        self.navigationBar.addBackButtonToLeft().rx.tap
            .subscribeNext(weak: self, type(of: self).tapBack)
            .disposed(by: self.disposeBag)
        self.navigationBar.addButtonToRight(image: R.image.ic_search_options()).rx.tap
            .subscribeNext(weak: self, type(of: self).tapOptions)
            .disposed(by: self.disposeBag)
        self.navigationBar.titleView = self.searchView
        self.searchView.textField.becomeFirstResponder()
        self.collectionView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
    }
    
    override func back(
        type: BackType? = nil, animated: Bool = true,
        result: Any? = nil, cancel: Bool = false, message: String? = nil
    ) {
        super.back(type: type, animated: false, result: result, cancel: cancel, message: message)
    }
    
    func tapOptions(_: Void? = nil) {
        self.navigator.presentX(
            Router.shared.urlString(host: .search, path: .options),
            wrap: NavigationController.self
        )
    }
    
    override func header(
        _ collectionView: UICollectionView,
        for indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeue(
            Reusable.searchHistoryHeader,
            kind: UICollectionView.elementKindSectionHeader,
            for: indexPath
        )
        header.bind(reactor: self.reactor!, section: indexPath.section)
        header.rx.clear
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.clear(indexPath.section)
            })
            .disposed(by: header.rx.disposeBag)
        return header
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        if self.reactor?.currentState.contents[section].header == nil {
            return .zero
        }
        return .init(width: collectionView.sectionWidth(at: section), height: 50)
    }

    func clear(_ section: Int) {
        var configuration = self.reactor?.currentState.configuration as? Configuration
        configuration?.keywords = []
        Subjection.update(Configuration.self, configuration, true)
        self.reactor?.action.onNext(.reload)
    }
    
}

extension SearchHistoryViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = textField.text, query.isNotEmpty {
            self.tapQuery(query: query)
            return true
        }
        return false
    }

}
