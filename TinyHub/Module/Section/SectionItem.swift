//
//  SectionItem.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import Foundation
import RxDataSources
import ReusableKit_Hi
import ObjectMapper_Hi
import HiIOS

enum SectionItem: IdentifiableType, Equatable {
    case simple(SimpleItem)
    case appInfo(AppInfoItem)
    case milestone(MilestoneItem)
    case repoBasic(RepoBasicItem)
    case repoDetail(RepoDetailItem)
    case userPlain(UserPlainItem)
    case userBasic(UserBasicItem)
    case userDetail(UserDetailItem)
    case searchKeywords(SearchKeywordsItem)
    case feedback(FeedbackItem)
    case event(EventItem)
    case issue(IssueItem)
    case language(LanguageItem)
    case degree(DegreeItem)
    case label(LabelItem)
    case button(ButtonItem)
    case check(CheckItem)
    case textField(TextFieldItem)
    case textView(TextViewItem)
    case imageView(ImageViewItem)
    case codeView(CodeViewItem)
    case dirSingle(DirSingleItem)
    case dirMultiple(DirMultipleItem)
    case branch(BranchItem)
    case pull(PullItem)
    case readmeContent(ReadmeContentItem)
    case urlScheme(URLSchemeItem)
    case theme(ThemeItem)
    
    var identity: String {
        var string = ""
        switch self {
        case let .simple(item): string = item.description
        case let .appInfo(item): string = item.description
        case let .milestone(item): string = item.description
        case let .userDetail(item): string = item.description
        case let .userBasic(item): string = item.description
        case let .userPlain(item): string = item.description
        case let .repoBasic(item): string = item.description
        case let .repoDetail(item): string = item.description
        case let .searchKeywords(item): string = item.description
        case let .feedback(item): string = item.description
        case let .event(item): string = item.description
        case let .issue(item): string = item.description
        case let .language(item): string = item.description
        case let .degree(item): string = item.description
        case let .dirSingle(item): string = item.description
        case let .dirMultiple(item): string = item.description
        case let .label(item): string = item.description
        case let .button(item): string = item.description
        case let .check(item): string = item.description
        case let .textField(item): string = item.description
        case let .textView(item): string = item.description
        case let .imageView(item): string = item.description
        case let .codeView(item): string = item.description
        case let .branch(item): string = item.description
        case let .pull(item): string = item.description
        case let .readmeContent(item): string = item.description
        case let .urlScheme(item): string = item.description
        case let .theme(item): string = item.description
        }
        return string // String.init(string.sorted())
    }

    // swiftlint:disable cyclomatic_complexity
    static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
        let result = (lhs.identity == rhs.identity)
        if result == false {
            switch lhs {
            case .simple: log("item变化 -> simple")
            case .appInfo: log("item变化 -> appInfo")
            case .milestone: log("item变化 -> milestone")
            case .userDetail: log("item变化 -> userDetail")
            case .userBasic: log("item变化 -> userBasic")
            case .userPlain: log("item变化 -> userPlain")
            case .repoBasic: log("item变化 -> repoBasic")
            case .repoDetail: log("item变化 -> repoDetail")
            case .searchKeywords: log("item变化 -> searchKeywords")
            case .feedback: log("item变化 -> feedback")
            case .event: log("item变化 -> event")
            case .issue: log("item变化 -> issue")
            case .language: log("item变化 -> language")
            case .degree: log("item变化 -> degree")
            case .dirSingle: log("item变化 -> dirSingle")
            case .dirMultiple: log("item变化 -> dirMultiple")
            case .label: log("item变化 -> label")
            case .button: log("item变化 -> button")
            case .check: log("item变化 -> check")
            case .textField: log("item变化 -> textField")
            case .textView: log("item变化 -> textView")
            case .imageView: log("item变化 -> imageView")
            case .codeView: log("item变化 -> codeView")
            case .branch: log("item变化 -> branch")
            case .pull: log("item变化 -> pull")
            case .readmeContent: log("item变化 -> readmeContent")
            case .urlScheme: log("item变化 -> urlScheme")
            case .theme: log("item变化 -> theme")
            }
        }
        return result
    }
    // swiftlint:enable cyclomatic_complexity
    
}
