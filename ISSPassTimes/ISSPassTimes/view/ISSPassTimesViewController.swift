//
//  ViewController.swift
//  ISSPassTimes
//
//  Created by Raghunath, Karthik Raja (Contractor) on 12/24/17.
//  Copyright © 2017 Raghunath, Karthik Raja (Contractor). All rights reserved.
//

import UIKit


class ISSPassTimesViewController: UIViewController,UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  var viewModel = ISSPassTimesViewModel()
  
  // MARK: - View Controller life cycle.
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initialize()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - View action methods.
  
  @IBAction func refreshAction(_ sender: Any) {
    self.viewModel.fetchCurrentLocationIssPassTimes()
  }
  
  // MARK: - Functional methods.
  func initialize()  {
    self.viewModel.fetchCurrentLocationIssPassTimes()
    self.viewModel.modelArray.bindFire(listener: { (value) in
      self.tableView.reloadData()
    })
    self.viewModel.apiProgressState.bindFire { (value) in
      switch value {
      case .inProgress:
        self.title = "In Progress..."
      case .failed:
        self.title = "Failed"
      case .success(let latitude,let longitude):
        var title = ""
        if let latitude = latitude {
          title = title + "lat:" + String(latitude)
        }
        if let longitude = longitude {
          title = title + ", long:" + String(longitude)
        }
        self.title = title
      default:
        self.title = ""
      }
    }
  }
  
  
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.modelArray.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let modelArray = viewModel.modelArray.value
    let model = modelArray[indexPath.row]
    cell.textLabel?.text = model.risetime ?? ""
    cell.detailTextLabel?.text = (model.duration ?? "0") + " secs"
    return cell
  }
  
}

