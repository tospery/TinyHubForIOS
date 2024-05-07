//
//  Content.swift
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
import ReusableKit_Hi
import ObjectMapper_Hi

enum ContentType: String, Codable {
    case unknown, file, dir, symlink, submodule
    
    var priority: Int {
        switch self {
        case .dir: return 0
        case .file: return 1
        case .symlink: return 2
        case .submodule: return 3
        case .unknown: return 4
        }
    }

}

struct Content: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    var links: Link?
    var content: String?
    var downloadUrl: String?
    var encoding: String?
    var gitUrl: String?
    var htmlUrl: String?
    var name: String?
    var path: String?
    var size: Int?
    var type: ContentType?
    var url: String?
    var isReadme = false
    var htmlString: String?
    var heights = [CGFloat].init()
    var unfold = false
    var tree = [String].init()
    var children = [Content].init() {
        didSet {
            self.unfold = false
        }
    }
    
    var sha: String { self.id }
    var isDir: Bool { self.type == .dir }
    
    var icon: UIImage? {
        guard let type = self.type else {
            return R.image.ic_file_unknown()
        }
        switch type {
        case .unknown: return R.image.ic_file_unknown()
        case .file:
            guard let lang = self.name?.fileExt?.fileLang else {
                return R.image.ic_file_unknown()
            }
            switch lang {
            case "txt": return R.image.ic_file_txt()
            case "yaml": return R.image.ic_file_yaml()
            case "json": return R.image.ic_file_json()
            case "html": return R.image.ic_file_html()
            case "license": return R.image.ic_file_license()
            case "markdown": return R.image.ic_file_markdown()
            case "podspec": return R.image.ic_file_podspec()
            default: return R.image.ic_file_code()
            }
        case .dir: return R.image.ic_file_dir()
        case .symlink: return R.image.ic_file_symlink()
        case .submodule: return R.image.ic_file_submodule()
        }
    }
    
//    var html: String? {
//        guard let content = self.content else { return nil }
//        guard let data = Data.init(base64Encoded: content, options: .ignoreUnknownCharacters) else { return nil }
//        guard let markdown = String.init(data: data, encoding: .utf8) else { return nil }
//        let parser = MarkdownParser()
//        let html = parser.html(from: markdown)
//        return html
//    }
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["sha"]
        links           <- map["_links"]
        content         <- map["content"]
        downloadUrl     <- map["download_url"]
        encoding        <- map["encoding"]
        gitUrl          <- map["git_url"]
        htmlUrl         <- map["html_url"]
        name            <- map["name"]
        path            <- map["path"]
        size            <- map["size"]
        type            <- map["type"]
        url             <- map["url"]
        heights         <- map["heights"]
        unfold          <- map["unfold"]
        tree            <- map["tree"]
        children        <- map["children"]
        htmlString      <- map["htmlString"]
        isReadme        <- map["isReadme"]
    }
    
    mutating func update() {
        var update = [Content].init()
        for var item in self.children {
            var myTree = self.tree
            myTree.append(self.id)
            item.tree = myTree
            update.append(item)
        }
        self.children = update
    }
    
    static func count(for content: Content) -> Int {
        var num = 1
        for item in content.children {
            num += count(for: item)
        }
        return num
    }
    
}
