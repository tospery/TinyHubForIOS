//
//  ShareManager.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/1.
//

import UIKit
import BonMot

class ShareManager: NSObject {

    static let shared = ShareManager()

    override init() {
        super.init()
    }
    
    func native(title: String, image: UIImage, url: URL) {
        guard let top = UIViewController.topMost else { return }
        let vc = UIActivityViewController(
            activityItems: [title, image, url],
            applicationActivities: nil
        )
        top.present(vc, animated: true) {
            log("本地分享完成block")
        }
    }

}
