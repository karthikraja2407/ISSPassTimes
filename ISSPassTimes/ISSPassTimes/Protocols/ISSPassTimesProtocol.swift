//
//  ISSPassTimesProtocol.swift
//  ISSPassTimes
//
//  Created by Raghunath, Karthik Raja (Contractor) on 12/24/17.
//  Copyright © 2017 Raghunath, Karthik Raja (Contractor). All rights reserved.
//

import Foundation

protocol ISSPassTimesProtocol {
  var modelArray:Dynamic<Array<ISSPassTimes>> {get}
  var latitude:Double? {get}
  var longitude:Double? {get}
  
  // MARK: - functional methods
  
  /**
   fetchISSPassContent method fires a API request and fetches the data
   
   - parameter latitude: current latitude value
   - parameter longitude: current longitude value
   */
  func fetchISSPassContent(latitude:Double,longitude:Double) -> Void
  
  /**
   parseISSData method parses the API response
   
   - parameter result: API response data as NSDictionary
   */
  func parseISSData(result:NSDictionary) -> Void
}
