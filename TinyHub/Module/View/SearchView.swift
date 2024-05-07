//
//  SearchView.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/13.
//

import UIKit
import HiIOS
import BonMot
import RxSwift
import RxCocoa
import RxGesture

class SearchView: BaseView {
    
    var margin = 0.f
    
    lazy var textField: UITextField = {
        let field = UITextField.init()
        field.textAlignment = .left
        field.keyboardType = .default
        field.returnKeyType = .search
        field.leftView = .init(frame: .init(x: 0, y: 0, width: 18, height: 0))
        field.leftViewMode = .always
        field.font = .normal(14)
        field.attributedPlaceholder = .composed(of: [
            R.image.ic_search()!.styled(with: .baselineOffset(-1)),
            Special.space,
            R.string.localizable.searchHintText(
                preferredLanguages: myLangs
            ).styled(with: .baselineOffset(2))
        ]).styled(with: .color(.footer), .font(.normal(14)))
        field.theme.textColor = themeService.attribute { $0.titleColor }
        field.theme.backgroundColor = themeService.attribute { $0.borderColor }
        field.sizeToFit()
        field.height = 34
        field.layerCornerRadius = field.height / 2.f
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        self.addSubview(self.textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.width = self.width - self.margin * 2
        self.textField.left = self.textField.leftWhenCenter
        self.textField.top = self.textField.topWhenCenter
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: deviceWidth, height: navigationBarHeight)
    }
    
}

extension Reactive where Base: SearchView {
    var click: ControlEvent<Void> {
        let source = base.rx.tapGesture().when(.recognized).map { _ in }
        return ControlEvent(events: source)
    }
    
    var text: ControlProperty<String?> {
        self.base.textField.rx.text
    }
}
