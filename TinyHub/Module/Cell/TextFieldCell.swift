//
//  TextFieldCell.swift
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
import HiIOS

class TextFieldCell: BaseCollectionCell, ReactorKit.View {
    
    lazy var textField: UITextField = {
        let field = UITextField.init()
        field.font = .normal(16)
        field.theme.textColor = themeService.attribute { $0.foregroundColor }
        field.sizeToFit()
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.textField)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.sizeToFit()
        self.textField.width = self.contentView.width - 20 * 2
        self.textField.height = self.contentView.height * 0.9
        self.textField.left = self.textField.leftWhenCenter
        self.textField.top = self.textField.topWhenCenter
    }

    func bind(reactor: TextFieldItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.text }
            .distinctUntilChanged()
            .bind(to: self.textField.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 44)
    }

}

extension Reactive where Base: TextFieldCell {
    
    var text: ControlProperty<String?> {
        self.base.textField.rx.text
    }
    
}
