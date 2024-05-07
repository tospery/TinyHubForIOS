//
//  Date+Ex.swift
//  TinyHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation

extension Date {
    
    init?(iso8601: String) {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: iso8601) else { return nil }
        self = date
    }

}
