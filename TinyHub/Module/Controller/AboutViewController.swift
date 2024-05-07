//
//  AboutViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import ReusableKit_Hi
import ObjectMapper_Hi
import RxDataSources
import RxGesture
import MessageUI
import HiIOS

class AboutViewController: ListViewController {
    
    var count = 0
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tapLogo(_: Void? = nil) {
        self.count += 1
        if self.count == 10 {
            self.count = 0
            UIPasteboard.general.string = UIDevice.current.uuid
            self.navigator.toastMessage(R.string.localizable.toastUUIDMessage(
                preferredLanguages: myLangs
            ))
        }
    }
    
    override func tapItem(sectionItem: SectionItem) {
        super.tapItem(sectionItem: sectionItem)
        switch sectionItem {
        case let .simple(item):
            guard let simple = item.model as? Simple else { return }
            guard let cellId = CellId.init(rawValue: simple.id) else { return }
            if cellId == .qqgroup {
                self.qqgroup()
            } else if cellId == .score {
                self.score()
            } else if cellId == .share {
                self.share()
            }
        default:
            break
        }
    }
    
    func qqgroup() {
        var string = "mqqapi://card/show_pslcard?src_type=internal&version=1&uin="
        string += "700671375&key=b994eba3669a2670f6bb423b675552ac812e22a1b32d7e7c3a647172fa3dd12a"
        string += "&card_type=group&source=external&jump_from=webapi"
        guard let url = string.url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(
                "https://apps.apple.com/cn/app/id444934666".url!,
                options: [:],
                completionHandler: nil
            )
        }
    }
    
    func score() {
        guard let url = "itms-apps://itunes.apple.com/cn/app/id1571034420?mt=8&action=write-review".url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func share() {
        if !MFMessageComposeViewController.canSendText() {
            return
        }
        let controller = MFMessageComposeViewController.init()
        controller.body = "https://apps.apple.com/cn/app/tinyhub/id1571034420"
        controller.messageComposeDelegate = self
        controller.navigationBar.tintColor = .primary
        self.present(controller, animated: true)
        
//        let shareObject = UMShareWebpageObject.shareObject(
//            withTitle: "分享标题", descr: "分享内容描述", thumImage: R.image.ic_about()
//        )
//        shareObject?.webpageUrl = "http://mobile.umeng.com/social"
//        let messageObject = UMSocialMessageObject.init()
//        messageObject.shareObject = shareObject
//        UMSocialManager.default().share(
//            to: .QQ, messageObject: messageObject, currentViewController: self
//        ) { result, error in
//            if let error = error {
//                log("分享error: \(error)")
//            } else {
//                log("分享结果: \(result)")
//            }
//        }
    }
    
}

extension AboutViewController: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(
        _ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult
    ) {
        self.dismiss(animated: true)
    }
    
}
