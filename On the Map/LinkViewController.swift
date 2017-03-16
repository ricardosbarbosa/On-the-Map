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
    }
    
  }

  @IBAction func submitAction(_ sender: Any) {
    let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
    request.httpMethod = "POST"
    request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    guard
      let uniqueKey = ListOfStudentsLocations.sharedInstance.user?.studentLocation?.uniqueKey,
      let firstName = ListOfStudentsLocations.sharedInstance.user?.studentLocation?.firstName,
      let lastName = ListOfStudentsLocations.sharedInstance.user?.studentLocation?.lastName
    else {
      return
    }
    
    request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(link)\",\"latitude\": \(placemark?.location?.coordinate.latitude), \"longitude\": \(placemark?.location?.coordinate.longitude)}".data(using: String.Encoding.utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      if error != nil { // Handle error…
        return
      }
      print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
    }
    task.resume()

  }

}
