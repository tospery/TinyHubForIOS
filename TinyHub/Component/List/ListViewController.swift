//
//  ListViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi
import Kingfisher
import RxDataSources
import RxGesture

// swiftlint:disable type_body_length file_length
class ListViewController: GeneralViewController {
    
    struct Reusable {
        static let simpleCell = ReusableCell<SimpleCell>()
        static let appInfoCell = ReusableCell<AppInfoCell>()
        static let milestoneCell = ReusableCell<MilestoneCell>()
        static let repoBasicCell = ReusableCell<RepoBasicCell>()
        static let repoDetailCell = ReusableCell<RepoDetailCell>()
        static let userPlainCell = ReusableCell<UserPlainCell>()
        static let userBasicCell = ReusableCell<UserBasicCell>()
        static let userDetailCell = ReusableCell<UserDetailCell>()
        static let searchKeywordsCell = ReusableCell<SearchKeywordsCell>()
        static let feedbackCell = ReusableCell<FeedbackCell>()
        static let eventCell = ReusableCell<EventCell>()
        static let issueCell = ReusableCell<IssueCell>()
        static let readmeContentCell = ReusableCell<ReadmeContentCell>()
        static let languageCell = ReusableCell<LanguageCell>()
        static let degreeCell = ReusableCell<DegreeCell>()
        static let dirSingleCell = ReusableCell<DirSingleCell>()
        static let dirMultipleCell = ReusableCell<DirMultipleCell>()
        static let checkCell = ReusableCell<CheckCell>()
        static let labelCell = ReusableCell<LabelCell>()
        static let buttonCell = ReusableCell<ButtonCell>()
        static let textFieldCell = ReusableCell<TextFieldCell>()
        static let textViewCell = ReusableCell<TextViewCell>()
        static let imageViewCell = ReusableCell<ImageViewCell>()
        static let codeViewCell = ReusableCell<CodeViewCell>()
        static let branchCell = ReusableCell<BranchCell>()
        static let pullCell = ReusableCell<PullCell>()
        static let themeCell = ReusableCell<ThemeCell>()
        static let urlSchemeCell = ReusableCell<URLSchemeCell>()
        static let baseHeader = ReusableView<BaseCollectionHeader>()
        static let baseFooter = ReusableView<BaseCollectionFooter>()
        static let searchHistoryHeader = ReusableView<SearchHistoryHeader>()
    }
    
    lazy var dataSource: RxCollectionViewSectionedReloadDataSource<Section> = {
        return .init(
            configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
                guard let `self` = self else { return collectionView.emptyCell(for: indexPath)}
                return self.cell(dataSource, collectionView, indexPath, sectionItem)
            },
            configureSupplementaryView: { [weak self] _, collectionView, kind, indexPath in
                guard let `self` = self else { return collectionView.emptyView(for: indexPath, kind: kind) }
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    return self.header(collectionView, for: indexPath)
                case UICollectionView.elementKindSectionFooter:
                    let footer = collectionView.dequeue(Reusable.baseFooter, kind: kind, for: indexPath)
                    footer.theme.backgroundColor = themeService.attribute { $0.lightColor }
                    return footer
                default:
                    return collectionView.emptyView(for: indexPath, kind: kind)
                }
            }
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(Reusable.simpleCell)
        self.collectionView.register(Reusable.appInfoCell)
        self.collectionView.register(Reusable.milestoneCell)
        self.collectionView.register(Reusable.userDetailCell)
        self.collectionView.register(Reusable.userBasicCell)
        self.collectionView.register(Reusable.userPlainCell)
        self.collectionView.register(Reusable.repoDetailCell)
        self.collectionView.register(Reusable.repoBasicCell)
        self.collectionView.register(Reusable.searchKeywordsCell)
        self.collectionView.register(Reusable.feedbackCell)
        self.collectionView.register(Reusable.eventCell)
        self.collectionView.register(Reusable.issueCell)
        self.collectionView.register(Reusable.languageCell)
        self.collectionView.register(Reusable.degreeCell)
        self.collectionView.register(Reusable.dirSingleCell)
        self.collectionView.register(Reusable.dirMultipleCell)
        self.collectionView.register(Reusable.labelCell)
        self.collectionView.register(Reusable.buttonCell)
        self.collectionView.register(Reusable.textFieldCell)
        self.collectionView.register(Reusable.textViewCell)
        self.collectionView.register(Reusable.codeViewCell)
        self.collectionView.register(Reusable.imageViewCell)
        self.collectionView.register(Reusable.branchCell)
        self.collectionView.register(Reusable.pullCell)
        self.collectionView.register(Reusable.checkCell)
        self.collectionView.register(Reusable.themeCell)
        self.collectionView.register(Reusable.readmeContentCell)
        self.collectionView.register(Reusable.urlSchemeCell)
        self.collectionView.register(Reusable.baseHeader, kind: .header)
        self.collectionView.register(Reusable.baseFooter, kind: .footer)
        self.collectionView.register(Reusable.searchHistoryHeader, kind: .header)
        self.collectionView.rx.itemSelected(dataSource: self.dataSource)
            .subscribeNext(weak: self, type(of: self).tapItem)
            .disposed(by: self.rx.disposeBag)
    }

    override func bind(reactor: GeneralViewReactor) {
        super.bind(reactor: reactor)
//        reactor.state.map { $0.user as? User }
//            .distinctUntilChanged()
//            .skip(1)
//            .subscribeNext(weak: self, type(of: self).handleUser)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.configuration as? Configuration }
//            .distinctUntilChanged()
//            .skip(1)
//            .subscribeNext(weak: self, type(of: self).handleConfiguration)
//            .disposed(by: self.disposeBag)
        // swiftlint:disable:next force_cast
        reactor.state.map { $0.sections as! [Section] }
            .distinctUntilChanged()
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - cell/header/footer
    // swiftlint:disable cyclomatic_complexity function_body_length
    func cell(
        _ dataSource: CollectionViewSectionedDataSource<Section>,
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ sectionItem: Section.Item
    ) -> UICollectionViewCell {
        switch sectionItem {
        case let .simple(item):
            let cell = collectionView.dequeue(Reusable.simpleCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .readmeContent(item):
            let cell = collectionView.dequeue(Reusable.readmeContentCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.click
                .subscribeNext(weak: self, type(of: self).handleTarget)
                .disposed(by: cell.disposeBag)
            return cell
        case let .appInfo(item):
            let cell = collectionView.dequeue(Reusable.appInfoCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.tapLogo
                .subscribeNext(weak: self, type(of: self).tapLogo)
                .disposed(by: cell.disposeBag)
            return cell
        case let .milestone(item):
            let cell = collectionView.dequeue(Reusable.milestoneCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .pull(item):
            let cell = collectionView.dequeue(Reusable.pullCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .theme(item):
            let cell = collectionView.dequeue(Reusable.themeCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .check(item):
            let cell = collectionView.dequeue(Reusable.checkCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .urlScheme(item):
            let cell = collectionView.dequeue(Reusable.urlSchemeCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .userDetail(item):
            let cell = collectionView.dequeue(Reusable.userDetailCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            Observable<String?>.merge([
                cell.statView.rx.tapFirst,
                cell.statView.rx.tapSecond,
                cell.statView.rx.tapThird
            ])
            .distinctUntilChanged()
            .map(Reactor.Action.target)
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.reactor!.action)
            .disposed(by: cell.disposeBag)
            return cell
        case let .userBasic(item):
            let cell = collectionView.dequeue(Reusable.userBasicCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.clickRepo
                .subscribeNext(weak: self, type(of: self).handleTarget)
                .disposed(by: cell.disposeBag)
            return cell
        case let .userPlain(item):
            let cell = collectionView.dequeue(Reusable.userPlainCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .repoDetail(item):
            let cell = collectionView.dequeue(Reusable.repoDetailCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.clickUser
                .map { Router.shared.urlString(host: .user, path: $0) }
                .subscribeNext(weak: self, type(of: self).handleTarget)
                .disposed(by: cell.disposeBag)
            Observable<String?>.merge([
                cell.statView.rx.tapFirst,
                cell.statView.rx.tapSecond,
                cell.statView.rx.tapThird
            ])
            .distinctUntilChanged()
            .map(Reactor.Action.target)
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.reactor!.action)
            .disposed(by: cell.disposeBag)
            return cell
        case let .repoBasic(item):
            let cell = collectionView.dequeue(Reusable.repoBasicCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.clickUser
                .map { Router.shared.urlString(host: .user, path: $0) }
                .subscribeNext(weak: self, type(of: self).handleTarget)
                .disposed(by: cell.disposeBag)
            return cell
        case let .searchKeywords(item):
            let cell = collectionView.dequeue(Reusable.searchKeywordsCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.select
                .subscribeNext(weak: self, type(of: self).tapQuery)
                .disposed(by: cell.disposeBag)
            return cell
        case let .feedback(item):
            let cell = collectionView.dequeue(Reusable.feedbackCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            Observable<String>.combineLatest([
                item.state.map { $0.title }.map {
                    $0?.isNotEmpty ?? false ? $0! : ""
                },
                cell.rx.body.asObservable().map {
                    $0?.isNotEmpty ?? false ? $0! : ""
                }
            ])
            .distinctUntilChanged()
            .map {
                Reactor.Action.data(
                    FeedbackViewReactor.Data.init(
                        title: $0.first?.isNotEmpty ?? false ? $0.first : nil,
                        body: $0.last?.isNotEmpty ?? false ? $0.last : nil
                    )
                )
            }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.reactor!.action)
            .disposed(by: cell.disposeBag)
            return cell
        case let .event(item):
            let cell = collectionView.dequeue(Reusable.eventCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.click
                .subscribeNext(weak: self, type(of: self).handleTarget)
                .disposed(by: cell.disposeBag)
            return cell
        case let .issue(item):
            let cell = collectionView.dequeue(Reusable.issueCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .language(item):
            let cell = collectionView.dequeue(Reusable.languageCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .degree(item):
            let cell = collectionView.dequeue(Reusable.degreeCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .codeView(item):
            let cell = collectionView.dequeue(Reusable.codeViewCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .branch(item):
            let cell = collectionView.dequeue(Reusable.branchCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .dirSingle(item):
            let cell = collectionView.dequeue(Reusable.dirSingleCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .dirMultiple(item):
            let cell = collectionView.dequeue(Reusable.dirMultipleCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.tapContent
                .map { Reactor.Action.execute(value: $0, active: true, needLogin: false) }
                .bind(to: self.reactor!.action)
                .disposed(by: cell.disposeBag)
            return cell
        case let .label(item):
            let cell = collectionView.dequeue(Reusable.labelCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.click
                .subscribeNext(weak: self, type(of: self).handleTarget)
                .disposed(by: cell.disposeBag)
            return cell
        case let .button(item):
            let cell = collectionView.dequeue(Reusable.buttonCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.tapButton
                .map { Reactor.Action.execute(value: nil, active: true, needLogin: false) }
                .bind(to: self.reactor!.action)
                .disposed(by: cell.disposeBag)
            return cell
        case let .imageView(item):
            let cell = collectionView.dequeue(Reusable.imageViewCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            return cell
        case let .textField(item):
            let cell = collectionView.dequeue(Reusable.textFieldCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.text
                .asObservable()
                .distinctUntilChanged()
                .map(Reactor.Action.data)
                .observe(on: MainScheduler.asyncInstance)
                .bind(to: self.reactor!.action)
                .disposed(by: cell.disposeBag)
            return cell
        case let .textView(item):
            let cell = collectionView.dequeue(Reusable.textViewCell, for: indexPath)
            item.parent = self.reactor
            cell.reactor = item
            cell.rx.text
                .asObservable()
                .distinctUntilChanged()
                .map(Reactor.Action.data)
                .observe(on: MainScheduler.asyncInstance)
                .bind(to: self.reactor!.action)
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length
    
    func header(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeue(
            Reusable.baseHeader,
            kind: UICollectionView.elementKindSectionHeader,
            for: indexPath
        )
        header.theme.backgroundColor = themeService.attribute { $0.lightColor }
        return header
    }
    
    // MARK: - handle
    override func handleUser(user: UserType?) {
        guard let user = user as? User else { return }
        if User.current == user {
            return
        }
        MainScheduler.asyncInstance.schedule(()) { _ -> Disposable in
            log("handleUser(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? "")) -> 更新用户，准备保存")
            User.update(user, reactive: true)
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
    override func handleConfiguration(configuration: ConfigurationType?) {
        super.handleConfiguration(configuration: configuration)
        guard let configuration = configuration as? Configuration else { return }
        MainScheduler.asyncInstance.schedule(()) { _ -> Disposable in
            Subjection.update(Configuration.self, configuration, true)
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
    // MARK: - tap
    // swiftlint:disable cyclomatic_complexity function_body_length
    func tapItem(sectionItem: SectionItem) {
        let username = (self.reactor as? TinyHub.ListViewReactor)?.username ?? ""
        let reponame = (self.reactor as? TinyHub.ListViewReactor)?.reponame ?? ""
        switch sectionItem {
        case let .simple(item):
            guard let simple = item.model as? Simple else { return }
            if let target = simple.target, target.isNotEmpty {
                self.navigator.jump(target)
                return
            }
            if let cellId = CellId.init(rawValue: simple.id) {
                switch cellId {
                case .language:
                    let ref = (self.reactor?.currentState.data as? RepoViewReactor.Data)?.branch?.id
                    let dft = (self.reactor?.currentState.data as? RepoViewReactor.Data)?.repo?.defaultBranch ?? ""
                    self.navigator.jump(Router.shared.urlString(host: .dir, parameters: [
                        Parameter.username: username,
                        Parameter.reponame: reponame,
                        Parameter.title: reponame,
                        Parameter.ref: ref ?? dft
                    ]))
                case .issues:
                    self.navigator.jump(
                        Router.shared.urlString(host: .page, parameters: [
                            Parameter.username: username,
                            Parameter.reponame: reponame,
                            Parameter.title: R.string.localizable.issues(
                                preferredLanguages: myLangs
                            ),
                            Parameter.pages: Page.stateValues.map { $0.rawValue }.jsonString() ?? ""
                        ])
                    )
                case .pulls:
                    self.navigator.jump(
                        Router.shared.urlString(host: .page, parameters: [
                            Parameter.username: username,
                            Parameter.reponame: reponame,
                            Parameter.title: R.string.localizable.pulls(
                                preferredLanguages: myLangs
                            ),
                            Parameter.pages: Page.stateValues.map { $0.rawValue }.jsonString() ?? ""
                        ])
                    )
                case .branches:
                    guard
                        let selected = (self.reactor?.currentState.data as? RepoViewReactor.Data)?.branch?.id,
                        selected.isNotEmpty
                    else { return }
                    self.navigator.rxPopup(.branches, context: [
                        Parameter.username: username,
                        Parameter.reponame: reponame,
                        Parameter.selected: selected
                    ]).subscribe(onNext: { [weak self] result in
                        guard let `self` = self else { return }
                        var data = self.reactor?.currentState.data as? RepoViewReactor.Data
                        data?.branch = result as? Branch
                        self.reactor?.action.onNext(.data(data))
                    }).disposed(by: self.disposeBag)
                case .readme:
                    guard
                        let url = (self.reactor?.currentState.data as? RepoViewReactor.Data)?.repo?.htmlUrl,
                        url.isNotEmpty
                    else { return }
                    self.navigator.jump(url, context: [
                        Parameter.routerForceWeb: true
                    ])
                default:
                    break
                }
            }
        case let .userBasic(item):
            guard let username = (item.model as? User)?.username else { return }
            self.navigator.jump(Router.shared.urlString(host: .user, path: username))
        case let .userPlain(item):
            guard let username = (item.model as? User)?.username else { return }
            self.navigator.jump(Router.shared.urlString(host: .user, path: username))
        case let .repoBasic(item):
            guard let url = (item.model as? Repo)?.htmlUrl, url.isNotEmpty else { return }
            self.navigator.jump(url)
        case let .event(item):
            guard let event = item.model as? Event else { return }
            switch event.type {
            case .create, .delete, .star:
                guard let name = event.repo?.name, name.isNotEmpty else { return }
                self.navigator.jump(Router.shared.urlString(host: .repo, path: name))
            case .pull:
                guard let url = event.payload?.pull?.htmlUrl else { return }
                self.navigator.jump(url)
            case .issueHandle, .issueComment:
                guard let url = event.payload?.issue?.htmlUrl else { return }
                self.navigator.jump(url)
            default:
                break
            }
        case let .issue(item):
            guard let url = (item.model as? Issue)?.htmlUrl else { return }
            self.navigator.jump(url)
        case let .pull(item):
            guard let url = (item.model as? Pull)?.htmlUrl else { return }
            self.navigator.jump(url)
        case let .language(item):
            guard let language = item.model as? Language else { return }
            MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
                guard let `self` = self else { fatalError() }
                self.reactor?.action.onNext(.execute(value: language, active: false, needLogin: false))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.back(result: language)
                }
                return Disposables.create {}
            }.disposed(by: self.disposeBag)
        case let .degree(item):
            guard let degree = item.model as? Degree else { return }
            MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
                guard let `self` = self else { fatalError() }
                self.reactor?.action.onNext(.execute(value: degree, active: false, needLogin: false))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.back()
                }
                return Disposables.create {}
            }.disposed(by: self.disposeBag)
        case let .dirSingle(item):
            guard let content = item.model as? Content else { return }
            MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
                guard let `self` = self else { fatalError() }
                self.reactor?.action.onNext(.execute(value: content, active: true, needLogin: false))
                return Disposables.create {}
            }.disposed(by: self.disposeBag)
        default:
            break
        }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length
    
    func tapUser(username: String) {
        self.navigator.jump(Router.shared.urlString(host: .user, path: username))
    }

    func tapQuery(query: String) {
        if query.isEmpty {
            return
        }
        var configuration = self.reactor?.currentState.configuration as? Configuration
        var keywords = configuration?.keywords ?? []
        keywords.removeFirst { $0 == query }
        keywords.insert(query, at: 0)
        configuration?.keywords = keywords
        Subjection.update(Configuration.self, configuration, true)
        self.navigator.pushX(
            Router.shared.urlString(host: .search, parameters: [
                Parameter.query: query
            ]),
            animated: false
        )
    }

    func tapLogo(_: Void? = nil) {
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    // swiftlint:disable cyclomatic_complexity
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .simple(item): return Reusable.simpleCell.class.size(width: width, item: item)
        case let .appInfo(item): return Reusable.appInfoCell.class.size(width: width, item: item)
        case let .milestone(item): return Reusable.milestoneCell.class.size(width: width, item: item)
        case let .userDetail(item): return Reusable.userDetailCell.class.size(width: width, item: item)
        case let .userBasic(item): return Reusable.userBasicCell.class.size(width: width, item: item)
        case let .userPlain(item): return Reusable.userPlainCell.class.size(width: width, item: item)
        case let .repoDetail(item): return Reusable.repoDetailCell.class.size(width: width, item: item)
        case let .repoBasic(item): return Reusable.repoBasicCell.class.size(width: width, item: item)
        case let .searchKeywords(item): return Reusable.searchKeywordsCell.class.size(width: width, item: item)
        case let .feedback(item): return Reusable.feedbackCell.class.size(width: width, item: item)
        case let .check(item): return Reusable.checkCell.class.size(width: width, item: item)
        case let .event(item): return Reusable.eventCell.class.size(width: width, item: item)
        case let .issue(item): return Reusable.issueCell.class.size(width: width, item: item)
        case let .language(item): return Reusable.languageCell.class.size(width: width, item: item)
        case let .degree(item): return Reusable.degreeCell.class.size(width: width, item: item)
        case let .dirSingle(item): return Reusable.dirSingleCell.class.size(width: width, item: item)
        case let .dirMultiple(item): return Reusable.dirMultipleCell.class.size(width: width, item: item)
        case let .label(item): return Reusable.labelCell.class.size(width: width, item: item)
        case let .button(item): return Reusable.buttonCell.class.size(width: width, item: item)
        case let .textField(item): return Reusable.textFieldCell.class.size(width: width, item: item)
        case let .textView(item): return Reusable.textViewCell.class.size(width: width, item: item)
        case let .imageView(item): return Reusable.imageViewCell.class.size(width: width, item: item)
        case let .codeView(item): return Reusable.codeViewCell.class.size(width: width, item: item)
        case let .branch(item): return Reusable.branchCell.class.size(width: width, item: item)
        case let .pull(item): return Reusable.pullCell.class.size(width: width, item: item)
        case let .readmeContent(item): return Reusable.readmeContentCell.class.size(width: width, item: item)
        case let .urlScheme(item): return Reusable.urlSchemeCell.class.size(width: width, item: item)
        case let .theme(item): return Reusable.themeCell.class.size(width: width, item: item)
        }
    }
    // swiftlint:enable cyclomatic_complexity
    
}
