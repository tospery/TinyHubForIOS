//
//  UIViewController+Ex.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/12/3.
//

import UIKit
import Parchment
import HiIOS

extension UIViewController {

    var pagingViewController: PagingViewController? {
        var parentVC = self.parent
        while parentVC != nil {
            if parentVC is PagingViewController {
                return parentVC as? PagingViewController
            }
            parentVC = parentVC?.parent
        }
        return nil
    }

}
