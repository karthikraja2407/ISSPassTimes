//
//  ISSPassTimesModel.swift
//  ISSPassTimes
//
//  Created by Raghunath, Karthik Raja (Contractor) on 12/24/17.
//  Copyright © 2017 Raghunath, Karthik Raja (Contractor). All rights reserved.
//

import Foundation
import SwiftyJSON

class ISSPassTimes {
  
  var duration:String?
  var risetime:String?
  
  init(json:JSON){
    if let duration = json["duration"].int {
      self.duration = String(duration)
    }
    
    if let risetime = json["risetime"].int {
      let date = Date(timeIntervalSince1970:TimeInterval(risetime))
      self.risetime = date.ReadableUTCDateFormatter()
    }
  }
}
