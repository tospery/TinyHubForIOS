//
//  LoginViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS
import SafariServices
import AuthenticationServices

class LoginViewReactor: ScrollViewReactor, ReactorKit.Reactor {

    enum Action {
        case login
        case oauth
        case accessToken(AccessToken?)
    }

    enum Mutation {
        case setActivating(Bool)
        case setError(Error?)
        case setTitle(String?)
        case setUser(User?)
        case setConfiguration(Configuration)
        case setAccessToken(AccessToken?)
        case setCode(String?)
    }

    struct State {
        var isActivating = false
        var error: Error?
        var title: String?
        var user: User?
        var configuration = Configuration.current!
        var accessToken: AccessToken?
        var code: String?
    }

    var authSession: Any?
    var initialState = State()

    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.login(
                preferredLanguages: myLangs
            )
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .accessToken(accessToken):
            return .concat([
                .just(.setError(nil)),
                .just(.setAccessToken(accessToken))
            ])
        case .login:
            return .concat([
                .just(.setError(nil)),
                .just(.setActivating(true)),
                self.login().map(Mutation.setUser),
                .just(.setActivating(false))
            ]).catch {
                Observable.concat([
                    .just(.setError($0)),
                    .just(.setActivating(false))
                ])
            }
        case .oauth:
            return .concat([
                .just(.setError(nil)),
                self.oauthCode().map(Mutation.setCode),
                .just(.setActivating(true)),
                self.oauthToken().map(Mutation.setAccessToken),
                self.login().map(Mutation.setUser),
                .just(.setActivating(false))
            ]).catch {
                .concat([
                    .just(.setError($0)),
                    .just(.setActivating(false))
                ])
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setActivating(isActivating):
            newState.isActivating = isActivating
        case let .setError(error):
            newState.error = error
        case let .setTitle(title):
            newState.title = title
        case let .setUser(user):
            newState.user = user
        case let .setCode(code):
            newState.code = code
        case let .setConfiguration(configuration):
            newState.configuration = configuration
        case let .setAccessToken(accessToken):
            newState.accessToken = accessToken
        }
        return newState
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        action
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        .merge(
            mutation,
            Subjection.for(Configuration.self)
                .distinctUntilChanged()
                .filterNil()
                .asObservable()
                .map(Mutation.setConfiguration)
        )
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        state
    }
    
    func oauthCode() -> Observable<String> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            let url = Router.Web.oauth.urlString.url!
            let scheme = UIApplication.shared.urlScheme
            let handler: (URL?, Error?) -> Void = { callback, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let code = callback?.queryValue(for: Parameter.code) else {
                    observer.onError(APPError.oauth)
                    return
                }
                observer.onNext(code)
                observer.onCompleted()
            }
            if #available(iOS 12, *) {
                let session = ASWebAuthenticationSession(
                    url: url,
                    callbackURLScheme: scheme,
                    completionHandler: handler
                )
                if #available(iOS 13.0, *) {
                    session.presentationContextProvider = self
                    session.prefersEphemeralWebBrowserSession = true
                }
                self.authSession = session
                session.start()
            } else {
                let session = SFAuthenticationSession(
                    url: url,
                    callbackURLScheme: scheme,
                    completionHandler: handler
                )
                self.authSession = session
                session.start()
            }
            return Disposables.create { [weak self] in
                guard let `self` = self else { return }
                if #available(iOS 12, *) {
                    (self.authSession as? ASWebAuthenticationSession)?.cancel()
                } else {
                    (self.authSession as? SFAuthenticationSession)?.cancel()
                }
            }
        }
    }
    
    func oauthToken() -> Observable<AccessToken> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let code = self.currentState.code, code.isNotEmpty else {
                observer.onError(APPError.login(nil))
                return Disposables.create { }
            }
            return self.provider.token(code: code)
                .asObservable()
                .subscribe(observer)
        }
    }

    func login() -> Observable<User> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var key = self.currentState.accessToken?.accessToken
            if key?.isEmpty ?? true {
                key = self.currentState.configuration.privateKey
            }
            guard let token = key, !token.isEmpty else {
                observer.onError(APPError.login(nil))
                return Disposables.create { }
            }
            return self.provider.login(token: token)
                .asObservable()
                .subscribe(observer)
        }
    }
    
}

extension LoginViewReactor: ASWebAuthenticationPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // return UIApplication.shared.keyWindow!
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
    }
}
