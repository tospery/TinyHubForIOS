//
//  ScrollViewController+Ex.swift
//  TinyHub
//
//  Created by liaoya on 2021/6/28.
//

import UIKit
import MJRefresh
import HiIOS

extension ScrollViewController {
    
    @objc func mySetupRefresh(should: Bool) {
        if should {
            let header = SWRefreshHeader.init(refreshingBlock: { [weak self] in
                guard let `self` = self else { return }
                self.refreshSubject.onNext(())
            })
            header.lastUpdatedTimeLabel?.isHidden = true
            header.stateLabel?.isHidden = true
            self.scrollView.mj_header = header
        } else {
            self.scrollView.mj_header?.removeFromSuperview()
            self.scrollView.mj_header = nil
        }
    }
    
    @objc func mySetupLoadMore(should: Bool) {
        self.mySetupLoadMore(should: should)
    }
    
}
