//
//  AliyunProvider.swift
//  TinyHub
//
//  Created by 杨建祥 on 2023/1/13.
//

import UIKit
import Umbrella
import HiIOS

class AliyunProvider: Umbrella.ProviderType {
    
    func log(_ eventName: String, parameters: [String: Any]?) {
        TinyHub.log("\(eventName): \(parameters ?? [:])", module: .aliyun)
#if DEBUG
#else
        let builder = ALBBMANCustomHitBuilder.init()
        builder.setEventLabel(eventName)
        if let parameters = parameters {
            builder.setProperties(parameters)
        }
        let traker = ALBBMANAnalytics.getInstance().getDefaultTracker()
        traker?.send(builder.build())
#endif
    }
    
}
