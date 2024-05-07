//
//  SectionItemElement.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import Foundation
import HiIOS

enum SectionItemElement {
    case appInfo
    case milestone
    case searchKeywords
    case feedback
    case check(CustomStringConvertible)
    case theme(ColorTheme)
    case label(LabelInfo)
    case button(String?)
    case textField(String?)
    case textView(String?)
    case imageView(ImageSource?)
    case codeView(lang: String?, code: String?)
    
    // swiftlint:disable cyclomatic_complexity
    func sectionItem(_ model: ModelType) -> SectionItem {
        switch self {
        case .appInfo: return .appInfo(.init(model))
        case .milestone: return .milestone(.init(model))
        case .searchKeywords: return .searchKeywords(.init(model))
        case .feedback: return .feedback(.init(model))
        case .check: return .check(.init(model))
        case .label: return .label(.init(model))
        case .theme: return .theme(.init(model))
        case .button: return .button(.init(model))
        case .textField: return .textField(.init(model))
        case .textView: return .textView(.init(model))
        case .imageView: return .imageView(.init(model))
        case .codeView: return .codeView(.init(model))
        }
    }
    // swiftlint:enable cyclomatic_complexity
    
}

extension SectionItemElement: CustomStringConvertible {
    var description: String {
        switch self {
        case .appInfo: return "appInfo"
        case .milestone: return "milestone"
        case .searchKeywords: return "searchKeywords"
        case .feedback: return "feedback"
        case let .check(name): return "check-\(name.description)"
        case let .label(info): return "label-\(info.description)"
        case let .theme(colorTheme): return "theme-\(colorTheme.description)"
        case let .button(text): return "button-\(text ?? "")"
        case let .textField(text): return "textField-\(text ?? "")"
        case let .textView(text): return "textView-\(text ?? "")"
        case let .codeView(_, code): return "file-\(code ?? "")"
        case let .imageView(image): return "imageView-\(String(describing: image))"
        }
    }
}
