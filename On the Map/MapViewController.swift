//
//  MapViewController.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 12/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

  var list = ListOfStudentsLocations.sharedInstance
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    list.addObserve(observer: self)
    self.mapView.addAnnotations(list.students)
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "unwindToMenuWithSegue" {
      logout()
    }
  }
  
  func logout() {
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
      if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
      request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      if error != nil { // Handle error…
        return
      }
      let range = Range(5 ..< data!.count)
      let newData = data?.subdata(in: range) /* subset response data! */
      print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
    }
    task.resume()
  }

  @IBAction func refreshAction(_ sender: Any) {
    list.refresh()
  }
  
  @IBAction func addMyLocationAction(_ sender: Any) {
  }
}
extension MapViewController : ListOfStudentsLocationsProtocol {
  func added(listOfStudentsLocationsProtocol: ListOfStudentsLocations) {
    let allAnnotations = self.mapView.annotations
    self.mapView.removeAnnotations(allAnnotations)
    //reload data
    mapView.addAnnotations(list.students)
    mapView.showAnnotations(list.students, animated: true)
  }
}
extension MapViewController : MKMapViewDelegate {
  
  // MARK: - MKMapViewDelegate
  
  // Here we create a view with a "right callout accessory view". You might choose to look into other
  // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
  // method in TableViewDataSource.
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
      pinView!.pinTintColor = .red
      pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    else {
      pinView!.annotation = annotation
    }
    
    return pinView
  }
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if let anotation = view.annotation {
      if let link = anotation.subtitle {
        UIApplication.shared.openURL(URL(string: link!)!)
      }
    }
  }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        list.refresh()
    }
}
