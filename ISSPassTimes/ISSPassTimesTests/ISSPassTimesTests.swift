//
//  ISSPassTimesTests.swift
//  ISSPassTimesTests
//
//  Created by Raghunath, Karthik Raja (Contractor) on 12/24/17.
//  Copyright © 2017 Raghunath, Karthik Raja (Contractor). All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import ISSPassTimes

class ISSPassTimesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAPISuccessParsing() {
      let bundle = Bundle(for: type(of: self))
      let fileURL = bundle.url(forResource: "ISSPassSuccess", withExtension: "json")
      let data = try! Data(contentsOf: fileURL!, options: .mappedIfSafe)
      let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
      let viewModel = ISSPassTimesViewModel()
      viewModel.parseISSData(result: jsonResult)
      XCTAssertTrue(viewModel.modelArray.value.count == 5, "The array parsed doesn't match with the expected count")
    }
  
  func testAPIFailureParsing() {
    let bundle = Bundle(for: type(of: self))
    let fileURL = bundle.url(forResource: "ISSPassFailure", withExtension: "json")
    let data = try! Data(contentsOf: fileURL!, options: .mappedIfSafe)
    let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
    let viewModel = ISSPassTimesViewModel()
    viewModel.parseISSData(result: jsonResult)
    XCTAssertTrue(viewModel.modelArray.value.count == 0, "The array parsed doesn't match with the expected count")
    XCTAssertEqual(String(describing: viewModel.apiProgressState.value), String(describing: APIProgressState.failed))
  }
  
  func testAPISuccess()  {
    let requestParams = ["lat":37.7873589,"lon":-122.408227]
    let expect = expectation(description: "Wait for ISS pass api completion")
    NetworkManager.get(API.passTimeUrl, parameters: requestParams as [String : AnyObject], success: {(result: NSDictionary) -> Void in
      let json = JSON(result)
      XCTAssertEqual(json["message"].string, "success")
      XCTAssertNotNil(json["response"].array, "Empty array is returned")
      expect.fulfill()
    }, failure: {(error: NSDictionary?) -> Void in
      XCTFail("Api failed with error :\(String(describing: error))")
    })
    wait(for: [expect], timeout: 60)
  }
  
  func testAPIFailure()  {
    //Given invalid lat and lon value to fail the API
    let requestParams = ["lat":137.7873589,"lon":122.408227]
    let expect = expectation(description: "Wait for ISS pass api completion")
    NetworkManager.get(API.passTimeUrl, parameters: requestParams as [String : AnyObject], success: {(result: NSDictionary) -> Void in
      let json = JSON(result)
      XCTAssertEqual(json["message"].string, "failure")
      XCTAssertNil(json["response"].array, "array is not empty")
      expect.fulfill()
    }, failure: {(error: NSDictionary?) -> Void in
      expect.fulfill()
      XCTFail("Api failed with error :\(String(describing: error))")
    })
    wait(for: [expect], timeout: 60)
  }
  
  func testLocator()  {
    let expect = expectation(description: "Wait for Locator to fetch current location")
    Locator.shared.locate { (result) in
      switch result{
      case .Success(let locator):
        if let location = locator.location {
          let latitude = location.coordinate.latitude
          let longitude = location.coordinate.longitude
          XCTAssertNotNil(latitude, "latitude is nil")
          XCTAssertNotNil(longitude, "longitude is nil")
          expect.fulfill()
        }else{
          XCTFail("Location is nil")
        }
      case .Failure(let error):
        XCTFail("Fetching Location is failed:\(String(describing:error))")
        expect.fulfill()
      }
    }
    wait(for: [expect], timeout: 60)
  }
  
  func testISSModel() {
    let bundle = Bundle(for: type(of: self))
    let fileURL = bundle.url(forResource: "ISSPassSuccess", withExtension: "json")
    let data = try! Data(contentsOf: fileURL!, options: .mappedIfSafe)
    let json = JSON(data)
    let duration = json["response"][0]["duration"].int
    let risetime = json["response"][0]["risetime"].int
    XCTAssertNotNil(duration, "duration is nil")
    XCTAssertNotNil(risetime, "risetime is nil")
  }
  
  func testDateFormatting() {
    //This is sample time in seconds
    let risetime = 1514222851
    let date = Date(timeIntervalSince1970:TimeInterval(risetime))
    let formattedDate = date.ReadableUTCDateFormatter()
    XCTAssertEqual(formattedDate, "2017-12-25 17:27:31")
  }
  
  func testfetchISSPassContent()  {
    let viewModel = ISSPassTimesViewModel()
    let _latitude = 37.7873589
    let _longitude = -122.408227
    let passes = 2
    viewModel.fetchISSPassContent(latitude: _latitude, longitude: _longitude, altitude: nil, passes: passes)
    let expect = expectation(description: "Wait for ISS pass API call")
    viewModel.apiProgressState.bindFire { (value) in
      switch value {
      case .failed:
        XCTFail("ISS pass API failed")
        expect.fulfill()
      case .success(let latitude,let longitude):
        XCTAssertEqual(latitude, _latitude)
        XCTAssertEqual(longitude, _longitude)
        XCTAssertTrue(viewModel.modelArray.value.count <= passes, "Number of passes doesn't matches")
        expect.fulfill()
      default:
        print("default do nothing")
      }
    }
    wait(for: [expect], timeout: 60)
  }
  
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
  
}

