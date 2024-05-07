//
//  RepoIconView.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/27.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import HiIOS

class RepoIconView: BaseView {
    
    lazy var label: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .bold(24)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layerCornerRadius = 4
        self.backgroundColor = .random
        self.addSubview(self.label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }
    
    override var intrinsicContentSize: CGSize {
        .init(40)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.sizeToFit()
        self.label.left = self.label.leftWhenCenter
        self.label.top = self.label.topWhenCenter
    }

}

extension Reactive where Base: RepoIconView {

    var repo: Binder<Repo?> {
        return Binder(self.base) { view, repo in
            view.backgroundColor = repo?.languageColor?.color ?? .random
            view.label.text = repo?.language?.firstCharacterAsString?.capitalized ?? "U"
            view.label.textColor = view.backgroundColor?.qmui_colorIsDark ?? false ? .background : .foreground
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

}
