//
//  Ext+Date.swift
//  MapLogTool
//
//  Created by D02020015 on 2021/6/1.
//

import Foundation

extension Date {
    
    func toDateTimeString(timeZone: TimeZone = .current/*date: Date*/) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm" //:ss
        formatter.timeZone = timeZone
        let datetimeString = formatter.string(from: self/*date*/)
        
        print(formatter.timeZone)
        return datetimeString
    }
    
    func toDateString(/*date: Date*/) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: self/*date*/)
        return dateString
    }
}
