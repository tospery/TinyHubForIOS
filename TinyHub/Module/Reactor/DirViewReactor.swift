//
//  DirViewReactor.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/15.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS

class DirViewReactor: ListViewReactor {
    
    let ref: String?
    let subpath: String?
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        self.ref = parameters?.string(for: Parameter.ref)
        self.subpath = parameters?.string(for: Parameter.subpath)
        super.init(provider, parameters)
    }
    
    override func requestRemote(_ mode: HiRequestMode, _ page: Int) -> Observable<Mutation> {
        self.provider.contents(
            username: self.username,
            reponame: self.reponame,
            subpath: self.subpath,
            ref: self.ref
        )
            .asObservable()
            .map { $0.sorted { $0.type?.priority ?? 0 < $1.type?.priority ?? 0 } }
            .map { .initial([.init(header: nil, models: $0)]) }
    }
    
    override func active(_ value: Any?) -> Observable<Mutation> {
        return Observable<Mutation>.create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let content = value as? Content else {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            if !content.isDir {
                log("点击文件：\(content.type?.rawValue ?? ""), \(content.name ?? "")")
                observer.onNext(.setTarget(Router.shared.urlString(host: .file, parameters: [
                    Parameter.title: content.name ?? "",
                    Parameter.url: content.downloadUrl ?? ""
                ])))
                observer.onCompleted()
                return Disposables.create { }
            }
            let models = self.currentState.contents.first?.models as? [Content] ?? []
            var tree = content.tree
            tree.append(content.sha)
            
            if content.unfold {
                observer.onNext(.initial([
                    .init(
                        header: nil,
                        models: self.remove(content: content, from: models, with: tree)
                    )
                ]))
                observer.onCompleted()
                return Disposables.create { }
            }
            return self.provider.contents(
                username: self.username,
                reponame: self.reponame,
                subpath: content.path,
                ref: self.ref
            )
                .asObservable()
                .map { $0.sorted { $0.type?.priority ?? 0 < $1.type?.priority ?? 0 } }
                .map { children -> [HiContent] in
                    return [
                        .init(
                            header: nil,
                            models: self.add(add: children, to: content, for: models, with: tree)
                        )
                    ]
                }
                .map(Mutation.initial)
                .subscribe(observer)
        }
    }
    
    func add(
        add children: [Content], to content: Content, for models: [Content], with tree: [String]
    ) -> [Content] {
        var myModels = models
        for sha in tree {
            guard let myIndex = models.firstIndex(where: { $0.sha == sha }) else {
                continue
            }
            var myContent = models[myIndex]
            myModels.remove(at: myIndex)
            
            var myTree = tree
            myTree.removeAll(sha)
            
            var myChildren = children
            if myTree.count != 0 {
                myChildren = self.add(
                    add: children, to: myContent, for: myContent.children, with: myTree
                )
            }
            
            myContent.children = myChildren
            myContent.update()
            myModels.insert(myContent, at: myIndex)
        }
        return myModels
    }
    
    func remove(
        content: Content, from models: [Content], with tree: [String]
    ) -> [Content] {
        var myModels = models
        for sha in tree {
            guard let myIndex = models.firstIndex(where: { $0.sha == sha }) else {
                continue
            }
            var myContent = models[myIndex]
            myModels.remove(at: myIndex)
            
            var myTree = tree
            myTree.removeAll(sha)
            
            var myChildren = content.children
            if myTree.count != 0 {
                myChildren = self.remove(content: content, from: myContent.children, with: myTree)
            }
            
            myContent.children = myChildren
            myModels.insert(myContent, at: myIndex)
        }
        return myModels
    }
    
}
