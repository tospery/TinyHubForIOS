//
//  String+Ex.swift
//  TinyHub
//
//  Created by liaoya on 2021/6/28.
//

import Foundation
import DateToolsSwift_Hi

extension String {
    
    var method: String {
        self.replacingOccurrences(of: "/", with: " ").camelCased
    }
    
    // 文件扩展名
    var fileExt: String? {
        self.components(separatedBy: ".").last?.lowercased()
    }
    
    // 编程语言
    var fileLang: String {
        switch self {
        case "sh": return "shell"
        case "h", "m": return "objectivec"
        case "md": return "markdown"
        case "js", "cjs": return "javascript"
        case "ts": return "typescript"
        case "pl", "pm": return "perl"
        case "yml": return "yaml"
        case "kt": return "kotlin"
        case "resolved": return "json"
        case "txt": return "plaintext"
        case "htm", "mht", "asp": return "html"
        case "hh", "hp", "hxx", "hpp", "h++", "tcc",
            "c", "cc", "cp", "cxx", "c++": return "cpp"
        case "py", "py3", "pyc", "pyo", "pyd", "pyi",
            "pyx", "pyz", "pywz", "rpy", "pyde", "pyp", "pyt":
            return "python"
        case "rake", "rakefile", "gem", "gemspec", "bundler", "bundle",
            "gemfile", "gitignore":
            return "ruby"
        default:
            return self.lowercased()
        }
    }
    
    var dateAgo: String {
        guard let date = Date.init(iso8601: self) else { return self }
        return R.string.localizable.latestUpdate(
            date.timeAgoSinceNow,
            preferredLanguages: myLangs
        )
    }
    
    var dateShort: String {
        guard let date = Date.init(iso8601: self) else { return self }
        return date.string(withFormat: "yyyy-MM-dd")
    }
    
    var dateMiddle: String {
        guard let date = Date.init(iso8601: self) else { return self }
        return date.string(withFormat: "yyyy-MM-dd HH:mm")
    }
    
    var dateFull: String {
        guard let date = Date.init(iso8601: self) else { return self }
        return date.string(withFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    // repo url: https://api.github.com/repos/tospery/TinyHub
    var username: String {
        let result = self.apiString
        let base = result.url?.baseString ?? ""
        var prefix = "\(base)/users/"
        if result.hasPrefix(prefix) {
            return result.removingPrefix(prefix).components(separatedBy: "/").first ?? ""
        }
        prefix = "\(base)/repos/"
        if self.hasPrefix(prefix) {
            return result.removingPrefix(prefix).components(separatedBy: "/").first ?? ""
        }
        return ""
    }
    
    var reponame: String {
        let result = self.apiString
        let base = result.url?.baseString ?? ""
        let prefix = "\(base)/repos/"
        if result.hasPrefix(prefix) {
            return result.removingPrefix(prefix).components(separatedBy: "/")[safe: 1] ?? ""
        }
        return ""
    }
    
    var contentPath: String {
        let result = self.apiString
        let base = result.url?.baseString ?? ""
        let user = self.username
        let repo = self.reponame
        let prefix = "\(base)/repos/\(user)/\(repo)/contents/"
        return result.removingPrefix(prefix)
    }
    
    var apiPath: String {
        var result = self.apiString
        result = result.removingPrefix(UIApplication.shared.baseApiUrl)
        return result
    }
    
    var apiString: String {
        (try? NSRegularExpression.init(pattern: "(\\{[^\\}]+\\})"))?.stringByReplacingMatches(
            in: self,
            range: .init(location: 0, length: self.count),
            withTemplate: ""
        ) ?? self
    }
    
    // swiftlint:disable cyclomatic_complexity
    func localized(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else { return self }
        let tableName = "Localizable"
        let hostingBundle = Bundle.main
        // Filter preferredLanguages to localizations, use first locale
        var languages = preferredLanguages
            .map { Locale(identifier: $0) }
            .prefix(1)
            .flatMap { locale -> [String] in
                if hostingBundle.localizations.contains(locale.identifier) {
                    if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
                        return [locale.identifier, language]
                    } else {
                        return [locale.identifier]
                    }
                } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
                    return [language]
                } else {
                    return []
                }
            }

        // If there's no languages, use development language as backstop
        if languages.isEmpty {
          if let developmentLocalization = hostingBundle.developmentLocalization {
            languages = [developmentLocalization]
          }
        } else {
          // Insert Base as second item (between locale identifier and languageCode)
          languages.insert("Base", at: 1)

          // Add development language as backstop
          if let developmentLocalization = hostingBundle.developmentLocalization {
            languages.append(developmentLocalization)
          }
        }

        // Find first language for which table exists
        // Note: key might not exist in chosen language (in that case, key will be shown)
        for language in languages {
          if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
             let lbundle = Bundle(url: lproj) {
            let strings = lbundle.url(forResource: tableName, withExtension: "strings")
            let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

            if strings != nil || stringsdict != nil {
                return NSLocalizedString(self, bundle: lbundle, comment: "")
            }
          }
        }

        // If table is available in main bundle, don't look for localized resources
        let strings = hostingBundle.url(
            forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil
        )
        let stringsdict = hostingBundle.url(
            forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil
        )

        if strings != nil || stringsdict != nil {
            return NSLocalizedString(self, bundle: hostingBundle, comment: "")
        }

        return self
    }
    // swiftlint:enable cyclomatic_complexity
    
}
