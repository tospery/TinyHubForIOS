//
//  DirMultipleCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/16.
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
import HiIOS

class DirMultipleCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 44.f
    }
    
    struct Reusable {
        static let DirSingleCell = ReusableCell<DirSingleCell>()
        static let DirMultipleCell = ReusableCell<DirMultipleCell>()
    }
    
    let contentSubject = PublishSubject<Content>()
    
    lazy var dataSource: RxCollectionViewSectionedReloadDataSource<Section> = {
        return .init(
            configureCell: { [weak self] _, collectionView, indexPath, sectionItem in
                guard let `self` = self else { fatalError() }
                switch sectionItem {
                case let .dirSingle(item):
                    let cell = collectionView.dequeue(Reusable.DirSingleCell, for: indexPath)
                    cell.reactor = item
                    return cell
                case let .dirMultiple(item):
                    let cell = collectionView.dequeue(Reusable.DirMultipleCell, for: indexPath)
                    cell.reactor = item
                    //  self.contentSubject.onNext(content)
                    cell.rx.tapContent
                        .subscribeNext(weak: self, type(of: self).tapContent)
                        .disposed(by: cell.disposeBag)
                    return cell
                default:
                    return collectionView.emptyCell(for: indexPath)
                }
            }
        )
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        let view = UICollectionView.init(
            frame: .init(origin: .zero, size: .init(width: deviceWidth, height: 1)),
            collectionViewLayout: layout
        )
        view.delegate = self
        view.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.collectionView)
        self.collectionView.register(Reusable.DirSingleCell)
        self.collectionView.register(Reusable.DirMultipleCell)
        self.collectionView.rx.itemSelected(dataSource: self.dataSource)
            .subscribeNext(weak: self, type(of: self).tapItem)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.contentView.bounds
    }

    func bind(reactor: DirMultipleItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.sections }
            .distinctUntilChanged()
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    func tapItem(sectionItem: SectionItem) {
        switch sectionItem {
        case let .dirSingle(item):
            log("tapped dirSingle")
            guard let content = item.model as? Content else { return }
            self.contentSubject.onNext(content)
        case .dirMultiple:
            log("tapped dirMultiple")
        default:
            break
        }
    }
    
    func tapContent(content: Content) {
        self.contentSubject.onNext(content)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let content = item.model as? Content else { return .zero }
        return .init(
            width: width,
            height: Content.count(for: content).f * Metric.height
        )
    }

}

extension DirMultipleCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .dirSingle(item): return Reusable.DirSingleCell.class.size(width: width, item: item)
        case let .dirMultiple(item): return Reusable.DirMultipleCell.class.size(width: width, item: item)
        default: return .zero
        }
    }
    
}

extension Reactive where Base: DirMultipleCell {
    
    var tapContent: ControlEvent<Content> {
        let source = self.base.contentSubject
        return ControlEvent(events: source)
    }
    
}
