//
//  SWRefreshFooter.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/26.
//

import UIKit
import MJRefresh
import HiIOS

class SWRefreshFooter: MJRefreshBackGifFooter {

    override func prepare() {
        super.prepare()
        // 设置普通状态的动画图片
        var idles = [UIImage].init()
        for index in 1...20 {
            if let image = UIImage.init(named: "ic_refresh_idle\(index)") {
                idles.append(image)
            }
        }
        self.setImages(idles, for: .idle)
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        var refreshings = [UIImage].init()
        for index in 1...20 {
            if let image = UIImage.init(named: "ic_refresh_loading\(index)") {
                refreshings.append(image)
            }
        }
        self.setImages(refreshings, duration: 1.2, for: .pulling)
        
        // 设置正在刷新状态的动画图片
        self.setImages(refreshings, duration: 1.2, for: .refreshing)
    }
    
}
