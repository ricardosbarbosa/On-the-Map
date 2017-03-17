//
//  StudentsTableViewController.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 12/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import UIKit


class StudentsTableViewController: UITableViewController {

  let list = ListOfStudentsLocations.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    list.addObserve(observer: self)
  }
  
  @IBAction func add(_ sender: Any) {
  }
  
  @IBAction func refreshAction(_ sender: Any) {
    list.refresh{ (result, error) in
      if error != nil {
        showAlert("Erro", message: "It was not possible to refresh the student locations", vc: self)
      }
      
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.students.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    cell.imageView?.image = UIImage(named: "pin")
    cell.textLabel?.text = "\(list.students[indexPath.row].studentLocation?.firstName ?? "") \(list.students[indexPath.row].studentLocation?.lastName ?? "")"
    let updatedAt = list.students[indexPath.row].studentLocation?.updatedAt?.description ?? ""
    let media = list.students[indexPath.row].studentLocation?.mediaURL ?? ""
    cell.detailTextLabel?.text =  media + " " + updatedAt
    
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let link = list.students[indexPath.row].studentLocation?.mediaURL ?? ""
    if let url = URL(string: link) {
      UIApplication.shared.openURL(url)
    }
    
  }
  

}

extension StudentsTableViewController : ListOfStudentsLocationsProtocol {
  func added(listOfStudentsLocationsProtocol: ListOfStudentsLocations) {
    self.tableView.reloadData()
  }
  func errorDownloading() {
    showAlert("Erro", message: "Not possible to download locations", vc: self)
  }
}
