//
//  SearchHistoryHeader.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/17.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import HiIOS

class SearchHistoryHeader: BaseCollectionHeader {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.attributedText = .composed(of: [
            R.image.ic_search_history()!.template
                .styled(with: .baselineOffset(-4)),
            Special.space,
            Special.space,
            R.string.localizable.searchHistory(
                preferredLanguages: myLangs
            )
                .styled(with: .font(.normal(15)))
        ]).styled(with: .color(.title))
        label.sizeToFit()
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.ic_search_erase(), for: .normal)
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.addSubview(self.button)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.sizeToFit()
        self.titleLabel.left = 20
        self.titleLabel.top = self.titleLabel.topWhenCenter
        self.button.right = self.width - 30
        self.button.top = self.button.topWhenCenter
    }
    
    override func bind(reactor: BaseViewReactor, section: Int = 0) {
        super.bind(reactor: reactor, section: section)
        if let parent = reactor as? ListViewReactor {
            parent.state
                .map { state -> [Any] in
                    if state.contents.count <= section {
                        return []
                    }
                    return (state.contents[section].header as? BaseModel)?.data as? [Any] ?? []
                }
                .distinctUntilChanged { HiIOS.compareAny($0, $1) }
                .bind(to: self.rx.info)
                .disposed(by: self.disposeBag)
        }
    }
    
}

extension Reactive where Base: SearchHistoryHeader {

    var clear: ControlEvent<Void> {
        self.base.button.rx.tap
    }
    
    var info: Binder<[Any]> {
        return Binder(self.base) { header, info in
            guard info.count >= 3 else { return }
            guard let icon = info.first as? UIImage else { return }
            guard let title = info[1] as? String else { return }
            guard let image = info.last as? UIImage else { return }
            header.titleLabel.attributedText = .composed(of: [
                icon.template.styled(with: .baselineOffset(-4)),
                Special.space,
                Special.space,
                title.styled(with: .font(.normal(15)))
            ]).styled(with: .color(.title))
            header.button.setImage(image, for: .normal)
            header.setNeedsLayout()
            header.layoutIfNeeded()
        }
    }

}
