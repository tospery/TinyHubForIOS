//
//  NavigationBarPagingViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/9.
//

import UIKit
import HiIOS
import Parchment
import SnapKit

class NavigationBarPagingViewController: PagingViewController {

    override func loadView() {
        view = NavigationBarPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view
        )
    }

}
