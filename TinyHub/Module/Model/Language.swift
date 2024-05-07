//
//  Language.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/30.
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

struct Language: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    var name: String?
    
    var urlParam: String { self.id }
    
    static let any = Language.init(id: "", name: "Any language")
    
    init() { }
    
    init(id: String, name: String?) {
        self.id = id
        self.name = name
    }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id          <- map["urlParam"]
        name        <- map["name"]
    }
    
}
