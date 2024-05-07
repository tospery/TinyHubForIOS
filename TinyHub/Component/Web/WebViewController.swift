//
//  WebViewController.swift
//  TinyHub
//
//  Created by liaoya on 2021/6/28.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class WebViewController: HiIOS.WebViewController {
    
    var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeButton = self.navigationBar.addCloseButtonToLeft()
        self.closeButton.isHidden = true
        self.closeButton.rx.tap
            .subscribeNext(weak: self, type(of: self).tapClose)
            .disposed(by: self.disposeBag)
    }
    
    override func tapBack(_: Void? = nil) {
        if self.webView.canGoBack {
            self.webView.goBack()
            return
        }
        super.tapBack()
    }
    
    func tapClose(_: Void? = nil) {
        self.back(cancel: true)
    }
    
    override func loadPage() {
        super.loadPage()
    }
    
    override func handle(_ handler: String, _ data: Any?) -> Any? {
        log("未处理的JS: \(handler)")
        return nil
    }
    
    override func webView(_ webView: WKWebView,
                          decidePolicyFor navigationAction: WKNavigationAction,
                          decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.closeButton.isHidden = !webView.canGoBack
        super.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    
}
