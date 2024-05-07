//
//  Error.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import Foundation
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi
import RxOptional
import RxSwiftExt
import NSObject_Rx
import RxDataSources
import RxViewController
import RxTheme

enum APPError: Error {
    case oauth
    case login(String?)
}

extension APPError: CustomNSError {
    var errorCode: Int {
        switch self {
        case .oauth: return 1
        case .login: return 2
        }
    }
}


extension APPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .oauth: return HiError.app(self.errorCode, nil, nil).errorDescription
        case let .login(message): return HiError.app(self.errorCode, message, nil).errorDescription
        }
    }
}

extension APPError: HiErrorCompatible {
    public var hiError: HiError {
        .app(self.errorCode, self.errorDescription, nil)
    }
}

extension RxOptionalError: HiErrorCompatible {
    public var hiError: HiError {
        switch self {
        case .emptyOccupiable: return .listIsEmpty
        case .foundNilWhileUnwrappingOptional: return .dataInvalid
        }
    }
}
