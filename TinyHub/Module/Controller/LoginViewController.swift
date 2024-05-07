//
//  LoginViewController.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class LoginViewController: ScrollViewController, ReactorKit.View {
    
    lazy var sloganLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(18)
        label.text = R.string.localizable.loginSlogan(
            preferredLanguages: myLangs
        )
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var privacyLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        label.font = .normal(12)
        label.text = R.string.localizable.loginPrivacy(
            UIApplication.shared.name, preferredLanguages: myLangs
        )
        label.theme.textColor = themeService.attribute { $0.footerColor }
        label.qmui_lineHeight = (label.qmui_lineHeight + 2).flat
        label.size = label.sizeThatFits(
            .init(
                width: deviceWidth - 20 * 2,
                height: .greatestFiniteMagnitude
            )
        )
        return label
    }()
    
    lazy var oauthLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(12)
        label.text = R.string.localizable.loginAuth(
            preferredLanguages: myLangs
        )
        label.theme.textColor = themeService.attribute { $0.footerColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(11)
        label.theme.textColor = themeService.attribute { $0.specialColors.color(for: Parameter.error) }
        label.sizeToFit()
        label.height = 25
        return label
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = R.image.appLogo()
        imageView.sizeToFit()
        imageView.size = .init(90)
        imageView.layerCornerRadius = imageView.height / 2.f
        return imageView
    }()
    
    lazy var tokenTextField: UITextField = {
        let textField = UITextField.init()
        textField.borderStyle = .roundedRect
        textField.font = .normal(15)
        textField.placeholder = R.string.localizable.loginPlaceholderToken(
            preferredLanguages: myLangs
        )
        textField.theme.textColor = themeService.attribute { $0.titleColor }
        textField.sizeToFit()
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.layerCornerRadius = 4
        button.titleLabel?.font = .normal(18)
        button.setTitle(R.string.localizable.login(
            preferredLanguages: myLangs
        ), for: .normal)
        button.theme.titleColor(
            from: themeService.attribute { $0.backgroundColor },
            for: .normal
        )
        button.theme.backgroundImage(
            from: themeService.attribute {
                UIImage.init(
                    color: $0.primaryColor,
                    size: .init(width: deviceWidth, height: 50)
                )
            },
            for: .normal
        )
        button.theme.backgroundImage(
            from: themeService.attribute {
                UIImage.init(
                    color: $0.primaryColor.withAlphaComponent(0.7),
                    size: .init(width: deviceWidth, height: 50)
                )
            },
            for: .disabled
        )
        button.sizeToFit()
        return button
    }()
    
    lazy var oauthButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.ic_github(), for: .normal)
        button.sizeToFit()
        return button
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        defer {
            self.reactor = reactor as? LoginViewReactor
        }
        super.init(navigator, reactor)
        self.transparetNavBar = reactor.parameters[Parameter.transparetNavBar] as? Bool ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.addSubview(self.sloganLabel)
        self.scrollView.addSubview(self.privacyLabel)
        self.scrollView.addSubview(self.oauthLabel)
        self.scrollView.addSubview(self.errorLabel)
        self.scrollView.addSubview(self.loginButton)
        self.scrollView.addSubview(self.oauthButton)
        self.scrollView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.tokenTextField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sloganLabel.left = self.sloganLabel.leftWhenCenter
        self.sloganLabel.top = (self.sloganLabel.topWhenCenter * 0.8).flat
        self.logoImageView.left = self.logoImageView.leftWhenCenter
        self.logoImageView.bottom = self.sloganLabel.top - 15
        self.tokenTextField.height = 44
        self.tokenTextField.width = self.scrollView.width - 20 * 2
        self.tokenTextField.left = self.tokenTextField.leftWhenCenter
        self.tokenTextField.top = self.sloganLabel.bottom + 30
        self.errorLabel.width = self.tokenTextField.width
        self.errorLabel.left = self.tokenTextField.left
        self.errorLabel.top = self.tokenTextField.bottom
        self.loginButton.height = 44
        self.loginButton.width = self.tokenTextField.width
        self.loginButton.left = self.loginButton.leftWhenCenter
        self.loginButton.top = self.errorLabel.bottom
        self.privacyLabel.left = self.loginButton.left
        self.privacyLabel.top = self.loginButton.bottom + 5
        self.oauthLabel.left = self.oauthLabel.leftWhenCenter
        self.oauthLabel.bottom = (self.scrollView.height - 30 - safeArea.bottom).flat
        self.oauthButton.left = self.oauthButton.leftWhenCenter
        self.oauthButton.bottom = self.oauthLabel.top - 15
    }
    
    func bind(reactor: LoginViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.token
            .distinctUntilChanged()
            .map { Reactor.Action.accessToken(.init(accessToken: $0)) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.login.map { Reactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.oauth.map { Reactor.Action.oauth }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.isActivating }
            .distinctUntilChanged()
            .bind(to: self.rx.activating)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.error }
            .distinctUntilChanged({ $0?.asHiError == $1?.asHiError })
            .bind(to: self.rx.error)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .skip(1)
            .filterNil()
            .subscribeNext(weak: self, type(of: self).handleUser)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.configuration.privateKey }
            .distinctUntilChanged()
            .bind(to: self.tokenTextField.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { [weak self] state -> Bool in
            guard let `self` = self else { return false }
            let token = state.accessToken?.accessToken?.isNotEmpty ?? false
            let key = self.tokenTextField.text?.isNotEmpty ?? false
            return token || key
        }
            .distinctUntilChanged()
            .filter { _ in !reactor.currentState.isActivating }
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }

    func handleUser(user: User) {
        if let username = user.username, username.isNotEmpty {
            ALBBMANAnalytics.getInstance().updateUserAccount(Parameter.username, userid: username)
        }
        Subjection.update(AccessToken.self, self.reactor?.currentState.accessToken)
        if let privateKey = self.tokenTextField.text, privateKey.isNotEmpty,
            privateKey == self.reactor?.currentState.accessToken?.accessToken {
            var configuration = self.reactor?.currentState.configuration
            configuration?.privateKey = privateKey
            Subjection.update(Configuration.self, configuration, false)
        }
        MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
            guard let `self` = self else { fatalError() }
            User.update(user, reactive: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.back(result: user)
            }
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
}

extension Reactive where Base: LoginViewController {

    var token: ControlProperty<String?> {
        self.base.tokenTextField.rx.text
    }
    
    var login: ControlEvent<Void> {
        self.base.loginButton.rx.tap
    }
    
    var oauth: ControlEvent<Void> {
        self.base.oauthButton.rx.tap
    }
    
    var error: Binder<Error?> {
        return Binder(self.base) { viewController, error in
             viewController.error = error
             guard viewController.isViewLoaded else { return }
            var message = error?.asHiError.localizedDescription
            if let hi = error?.asHiError, hi == .none {
                message = R.string.localizable.userCancelAuthorization(
                    preferredLanguages: myLangs
                )
            }
            viewController.errorLabel.text = message
        }
    }
    
}
