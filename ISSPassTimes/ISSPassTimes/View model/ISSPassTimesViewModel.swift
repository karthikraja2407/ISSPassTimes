//
//  ISSPassTimesViewModel.swift
//  ISSPassTimes
//
//  Created by Raghunath, Karthik Raja (Contractor) on 12/24/17.
//  Copyright © 2017 Raghunath, Karthik Raja (Contractor). All rights reserved.
//

import Foundation
import SwiftyJSON

enum APIProgressState {
  case none
  case inProgress
  case failed
  case success(latitude:Double?,longitude:Double?)
}

class ISSPassTimesViewModel:ISSPassTimesProtocol {
  var modelArray = Dynamic(value: [ISSPassTimes]())
  var apiProgressState = Dynamic(value:APIProgressState.none)
  var latitude:Double?
  var longitude:Double?
  
  func fetchCurrentLocationIssPassTimes() -> Void {
    self.apiProgressState.value = .inProgress
    Locator.shared.locate { (result) in
      switch result{
      case .Success(let locator):
        if let location = locator.location {
          self.latitude = location.coordinate.latitude
          self.longitude = location.coordinate.longitude
          //we are sure the latitude and longitude value exist ,hence we are force unwrapping the values.
          self.fetchISSPassContent(latitude: self.latitude!, longitude:self.longitude!)
          self.apiProgressState.value = .success(latitude:self.latitude,longitude:self.longitude)
        }
      case .Failure(let error):
        print("location api failed \(error)")
        self.apiProgressState.value = .failed
      }
    }
  }
  
  // MARK: - functional methods
  //fetchISSPassContent -  This method fires a API request and fetches the data to load Collection View.
  func fetchISSPassContent(latitude:Double,longitude:Double) {
    let requestParams = ["lat":latitude,"lon":longitude]
    apiProgressState.value = .inProgress
    NetworkManager.get(API.passTimeUrl, parameters: requestParams as [String : AnyObject], success: {(result: NSDictionary) -> Void in
      let jsonData = JSON(result)
      if let message = jsonData["message"].string, message == "success"{
        if let modelArray = jsonData["response"].array {
          var responseArray = Array<ISSPassTimes>()
          for jsonModel in modelArray {
            let issPassTimeModel = ISSPassTimes(json: jsonModel)
            responseArray.append(issPassTimeModel)
          }
          self.modelArray.value = responseArray
          
        }else{
          self.modelArray.value = []
        }
        self.apiProgressState.value = .success(latitude:self.latitude,longitude:self.longitude)
      }else{
        self.apiProgressState.value = .failed
      }
    }, failure: {(error: NSDictionary?) -> Void in
      self.apiProgressState.value = .failed
      self.modelArray.value = []
      print ("Api Failure : error is:\n \(String(describing: error))")
    })
  }
  
}

