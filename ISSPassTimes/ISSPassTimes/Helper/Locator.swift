//
//  Locator.swift
//  ISSPassTimes
//
//  Created by Raghunath, Karthik Raja (Contractor) on 12/24/17.
//  Copyright © 2017 Raghunath, Karthik Raja (Contractor). All rights reserved.
//

import Foundation
import MapKit

class Locator: NSObject, CLLocationManagerDelegate {
  enum Result <T> {
    case Success(T)
    case Failure(Error)
  }
  
  static let shared: Locator = Locator()
  
  typealias Callback = (Result <Locator>) -> Void
  
  var requests: Array <Callback> = Array <Callback>()
  
  var location: CLLocation? { return sharedLocationManager.location  }
  
  lazy var sharedLocationManager: CLLocationManager = {
    let newLocationmanager = CLLocationManager()
    newLocationmanager.delegate = self
    //need to handle when user denies the authorization to access the location.
    newLocationmanager.requestWhenInUseAuthorization()
    return newLocationmanager
  }()
  
  
  // MARK: - Helpers
  
  func locate(callback:@escaping Callback) {
    self.requests.append(callback)
    sharedLocationManager.startUpdatingLocation()
  }
  
  func reset() {
    self.requests = Array <Callback>()
    sharedLocationManager.stopUpdatingLocation()
  }
  
  // MARK: - Delegate
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    for request in self.requests { request(.Failure(error)) }
    reset()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for request in self.requests { request(.Success(self)) }
    self.reset()
  }
  
  
}
