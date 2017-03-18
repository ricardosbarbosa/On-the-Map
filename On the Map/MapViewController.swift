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
    added(listOfStudentsLocationsProtocol: list)
//    loadThePins()
  }
    
//  func loadThePins() {
//    list.refresh(completionHandler: { (data, error) in
//      if error != nil {
//        showAlert("Erro", message: "It was not possible to refresh the student locations", vc: self)
//      }
//    })
//  }
  
  @IBAction func refreshAction(_ sender: Any) {
    list.refresh { (result, error) in
      if error != nil {
        showAlert("Erro", message: "It was not possible to refresh the student locations", vc: self)
      }
    }
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
  
  func errorDownloading() {
    showAlert("Erro", message: "Not possible to download locations", vc: self)
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
      list.refresh{ (result, error) in
        if error != nil {
          showAlert("Erro", message: "It was not possible to refresh the student locations", vc: self)
        }
      }
    }
}
