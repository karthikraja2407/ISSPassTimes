//
//  Dynamic.swift
//  ISSPassTimes
//
//  Created by Raghunath, Karthik Raja (Contractor) on 12/24/17.
//  Copyright © 2017 Raghunath, Karthik Raja (Contractor). All rights reserved.
//

import Foundation

class Dynamic<T> {
  typealias Listener = (T) -> ()
  var listener : Listener?
  func bind(listener: Listener?) {
    self.listener = listener
  }
  
  func bindFire(listener : Listener?) {
    self.listener = listener
    listener?(value)
  }
  
  var value : T {
    didSet {
      listener?(value)
    }
    willSet {
      print("will set called")
    }
  }
  
  init(value:T) {
    self.value = value
  }
  
}

