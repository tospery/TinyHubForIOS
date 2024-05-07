//
//  ReadmeContentCell.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/20.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import Highlightr
import HiIOS

class ReadmeContentCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = safeArea.bottom + 1
    }
    
    let clickSubject = PublishSubject<String>()
    
    lazy var webView: WKWebView = {
        let js = """
var meta = document.createElement('meta');
meta.setAttribute('name', 'viewport');
meta.setAttribute('content', 'width=device-width,initial-scale=1.0, maximum-scale=1.0, user-scalable=no');
document.getElementsByTagName('head')[0].appendChild(meta);
"""
        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let controller = WKUserContentController()
        controller.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        let view = WKWebView(
            frame: CGRect(x: 0, y: 0, width: deviceWidth, height: Metric.height), configuration: config
        )
        view.navigationDelegate = self
        view.scrollView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            view.scrollView.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.webView)
        self.webView.scrollView.addObserver(
            self,
            forKeyPath: "contentSize",
            options: .new,
            context: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.webView.navigationDelegate = nil
        self.webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.webView.frame = self.contentView.bounds
    }

    func bind(reactor: ReadmeContentItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.html }
            .distinctUntilChanged()
            .bind(to: self.rx.html)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    // swiftlint:disable block_based_kvo
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard var readme = self.model as? Content else { return }
        if keyPath == "contentSize" {
            let height = self.webView.scrollView.contentSize.height.flat
            if height <= self.height {
                return
            }
            var heights = readme.heights
            heights.append(height)
            readme.heights = heights
            (self.reactor?.parent as? ListViewReactor)?.action.onNext(
                .execute(value: readme, active: false, needLogin: false)
            )
        }
    }
    // swiftlint:enable block_based_kvo
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let content = (item as? ReadmeContentItem)?.model as? Content else { return .zero }
        return .init(width: width, height: content.heights.last ?? 0.f + Metric.height)
    }

}

extension ReadmeContentCell: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let string = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        if string == "about:blank" {
            decisionHandler(.allow)
            return
        }
        guard var url = navigationAction.request.url?.absoluteString.urlDecoded else {
            decisionHandler(.allow)
            return
        }
        if url.hasPrefix("about:blank#") {
            url = string.removingPrefix("about:blank#")
            if url.count != 0 {
                // YJX_TODO 将该只传入到htmlString中，再重新load
                log("描点位置：\(url)")
            }
        }
        log("网页地址: \(string)")
        self.clickSubject.onNext(string)
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(
            "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'",
            completionHandler: nil
        )
    }

}

 extension Reactive where Base: ReadmeContentCell {

     var click: ControlEvent<String> {
         let source = self.base.clickSubject
         return ControlEvent(events: source)
     }
     
     var html: Binder<String?> {
         return Binder(self.base) { cell, html in
             cell.webView.loadHTMLString(html ?? "", baseURL: nil)
         }
     }
     
 }
