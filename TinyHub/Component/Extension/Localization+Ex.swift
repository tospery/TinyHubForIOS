//
//  Localization+Ex.swift
//  TinyHub
//
//  Created by 杨建祥 on 2024/3/21.
//

import Foundation
import RxSwift
import RxCocoa
import HiIOS

extension Localization: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .system: return R.string.localizable.followSystem(
            preferredLanguages: myLangs
        )
        case .chinese: return R.string.localizable.chinese(
            preferredLanguages: myLangs
        )
        case .english: return R.string.localizable.english(
            preferredLanguages: myLangs
        )
        }
    }
    
}
