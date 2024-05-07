//
//  FeedbackViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/6.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import BonMot
import HiIOS

class FeedbackViewReactor: ListViewReactor {
    
    struct Data {
        var title: String?
        var body: String?
    }
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
//        self.initialState = State(
//            title: self.title ?? R.string.localizable.feedback(
//                preferredLanguages: myLangs
//            )
//        )
        self.initialState.title = self.title ?? R.string.localizable.feedback(preferredLanguages: myLangs)
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        var models = [ModelType].init()
        models.append(Simple.init(height: 15))
        models.append(BaseModel.init(SectionItemElement.feedback))
        models.append(Simple.init(height: 30))
        models.append(BaseModel.init(SectionItemElement.button(R.string.localizable.submit(
            preferredLanguages: myLangs
        ))))
        let tips = R.string.localizable.feedbackNote(
            preferredLanguages: myLangs
        )
        let repo = "\(Author.username)/\(Author.reponame)"
        let attributedText = NSAttributedString.composed(of: [
            tips.attributedString(),
            Special.nextLine,
            repo.attributedString()
        ]).styled(with: .font(.normal(14)), .color(.title))
        models.append(
            BaseModel.init(
                SectionItemElement.label(.init(
                    attributedText: attributedText,
                    alignment: .right,
                    links: [repo: Router.shared.urlString(host: .page, parameters: [
                        Parameter.username: Author.username,
                        Parameter.reponame: Author.reponame,
                        Parameter.title: R.string.localizable.issues(
                            preferredLanguages: myLangs
                        ),
                        Parameter.pages: Page.stateValues.map { $0.rawValue }.jsonString() ?? ""
                    ])],
                    color: .light
                ))
            )
        )
        return .just(.initial([.init(header: nil, models: models)]))
    }
    
    override func active(_ value: Any?) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let feedback = self.currentState.data as? FeedbackViewReactor.Data,
                  let title = feedback.title, let body = feedback.body, title.isNotEmpty, body.isNotEmpty else {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            return self.provider.feedback(title: body, body: title)
                .asObservable()
                .mapTo(Mutation.setTarget(Router.shared.urlString(host: .back, parameters: [
                    Parameter.message: R.string.localizable.toastSubmitMessage(
                        preferredLanguages: myLangs
                    )
                ])))
                .subscribe(observer)
        }
    }

}
