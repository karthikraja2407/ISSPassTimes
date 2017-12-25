//
//  DateExtension.swift
//  ISSPassTimes
//
//  Created by Raghunath, Karthik Raja (Contractor) on 12/24/17.
//  Copyright © 2017 Raghunath, Karthik Raja (Contractor). All rights reserved.
//

import Foundation


extension Date {
  
  /**
   Date extension is used to format the date in a readable format.
   
   - returns: yyyy-MM-dd HH:mm:ss formatted string
   */
  func ReadableUTCDateFormatter() -> String {
    let formatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")!
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = timeZone    
    return formatter.string(from: self)
  }
}
