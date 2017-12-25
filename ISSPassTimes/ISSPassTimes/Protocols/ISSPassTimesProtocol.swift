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
  //fetContent -  This method fires a GET API request and fetches the list of ISS passes.
  func fetchISSPassContent(latitude:Double,longitude:Double) -> Void
}
