//
//  LinkViewController.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 14/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import UIKit
import MapKit

class LinkViewController: UIViewController {
  
  var placemark: CLPlacemark?
  var link: String?
  var mapString: String?
  
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var linkLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    linkLabel.text = link
    // not all places have thoroughfare & subThoroughfare so validate those values
    if let placemark = placemark {
      let annotation = MKPointAnnotation()
      annotation.coordinate = placemark.location!.coordinate
      mapView.addAnnotation(annotation)
      mapView.showAnnotations([annotation], animated: true)
    }
    
  }
  
  @IBAction func submitAction(_ sender: Any) {
    guard
      let uniqueKey = ListOfStudentsLocations.sharedInstance.user?.studentLocation?.uniqueKey,
      let firstName = ListOfStudentsLocations.sharedInstance.user?.studentLocation?.firstName,
      let lastName = ListOfStudentsLocations.sharedInstance.user?.studentLocation?.lastName,
      let mapString = mapString,
      let link = link,
      let latitude = placemark?.location?.coordinate.latitude,
      let longitude = placemark?.location?.coordinate.longitude
      else {
        return
    }
    
    var params : Dictionary<String, Any> = Dictionary()
    
    params["uniqueKey"] = uniqueKey
    params["firstName"] = firstName
    params["lastName"] = lastName
    params["mapString"] = mapString
    params["link"] = link
    params["latitude"] = latitude
    params["longitude"] = longitude
    
    if let objectId = ListOfStudentsLocations.sharedInstance.user?.studentLocation?.objectId  {
      params["objectId"] = objectId
      
      Api().update(params: params, completionHandler: { (updateAt, error) in
        if error != nil || updateAt == nil { // Handle error…
          showAlert("Error", message: "Not possible to post", vc: self)
          return
        }
        if let updateAt = updateAt {
          ListOfStudentsLocations.sharedInstance.user?.studentLocation?.updatedAt = updateAt.toDateTime()
          self.performSegue(withIdentifier: "unwindToMap", sender: nil)
        }
      })
      
    }
    else {
      
      Api().post(params: params, completionHandler: { (data, error) in
        if error != nil || data == nil  { // Handle error…
          showAlert("Error", message: "Not possible to post", vc: self)
          return
        }
        
        self.performSegue(withIdentifier: "unwindToMap", sender: nil)
      })
      
    }
    
  }
  
}
