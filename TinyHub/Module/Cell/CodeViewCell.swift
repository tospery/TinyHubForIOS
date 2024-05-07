//
//  CodeViewCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/17.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import Highlightr
import HiIOS

class CodeViewCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = deviceHeight - navigationContentTopConstant
    }
    
    var highlightr: Highlightr!
    var languages = [String].init()
    let textStorage = CodeAttributedString()
    
    lazy var layoutManager: NSLayoutManager = {
        let layout = NSLayoutManager()
        return layout
    }()
    
    lazy var textContainer: NSTextContainer = {
        let container = NSTextContainer(size: .init(width: deviceWidth, height: Metric.height))
        return container
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView.init(
            frame: .init(origin: .zero, size: .init(width: deviceWidth, height: Metric.height)),
            textContainer: self.textContainer
        )
        view.isEditable = false
        view.font = .normal(15)
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.theme.textColor = themeService.attribute { $0.foregroundColor }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutManager.addTextContainer(self.textContainer)
        self.textStorage.addLayoutManager(self.layoutManager)
        self.highlightr = self.textStorage.highlightr
        if let theme = highlightr.availableThemes().first {
            log("默认主题: \(theme)")
            self.highlightr.setTheme(to: theme)
        }
        self.contentView.addSubview(self.textView)
        self.languages = highlightr.supportedLanguages().sorted()
        log("语言列表: \(self.languages)")
        let themes = highlightr.availableThemes()
        log("主题列表: \(themes)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textView.sizeToFit()
        self.textView.frame = self.contentView.bounds
    }

    func bind(reactor: CodeViewItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.lang }
            .distinctUntilChanged()
            .bind(to: self.rx.lang)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.code }
            .distinctUntilChanged()
            .bind(to: self.textView.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: Metric.height)
    }

}

 extension Reactive where Base: CodeViewCell {

    var lang: Binder<String?> {
        return Binder(self.base) { cell, lang in
            guard let lang = lang else { return }
            if !cell.languages.contains(lang) {
                log("未能解析到的语言: \(lang)")
                analytics.log(.languageParseFail(name: lang))
                return
            }
            cell.textStorage.language = lang
            if let element = (cell.model as? BaseModel)?.data as? SectionItemElement {
                if case let .codeView(_, code) = element {
                    cell.textView.text = code
                }
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }

 }
