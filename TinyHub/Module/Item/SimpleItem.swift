//
//  SimpleItem.swift
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

class SimpleItem: HiIOS.SimpleItem {
    
    override func transform(mutation: Observable<SimpleItem.Mutation>) -> Observable<SimpleItem.Mutation> {
        .merge(
           mutation,
           Subjection.for(Configuration.self).map { $0?.localization }
               .distinctUntilChanged()
               .skip(1)
               .flatMap { [weak self] _ -> Observable<Mutation> in
                   guard let `self` = self else { return .empty() }
                   guard let simple = self.model as? Simple else { return .empty() }
                   guard let cellId = CellId.init(rawValue: simple.id) else { return .empty() }
                   if cellId.rawValue >= CellId.company.rawValue && cellId.rawValue <= CellId.bio.rawValue {
                       return .empty()
                   }
                   return .merge([
                       .just(.setTitle(cellId.title)),
                       .just(.setIcon(cellId.icon?.imageSource))
                   ])
               }
       )
    }
    
}
