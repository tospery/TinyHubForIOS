//
//  NavigationBarPagingView.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/9.
//

import UIKit
import HiIOS
import Parchment
import SnapKit

class NavigationBarPagingView: PagingView {

    override func setupConstraints() {
        pageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

}
