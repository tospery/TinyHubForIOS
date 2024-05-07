//
//  Configuration.swift
//  TinyHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator_Hi
import Rswift
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi

struct Configuration: ConfigurationType, Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    var theme = ColorTheme.indigo
    var localization = Localization.system
    var privateKey: String?
    var keywords = [String].init()
    var searchLanguage: Language? = Language.any
    var searchDegree: Degree? = Degree.default
    var searchIndex = 0
    var trendingLanguage: Language? = Language.any
    var trendingSince = Since.daily
    
    init() {
    }

    init(id: String) {
        self.id = id
    }
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id                  <- map["id"]
        theme               <- map["theme"]
        localization        <- map["localization"]
        privateKey          <- map["privateKey"]
        keywords            <- map["keywords"]
        searchLanguage      <- map["searchLanguage"]
        searchDegree        <- map["searchDegree"]
        searchIndex         <- map["searchIndex"]
        trendingLanguage    <- map["trendingLanguage"]
        trendingSince       <- map["trendingSince"]
    }
    
}
