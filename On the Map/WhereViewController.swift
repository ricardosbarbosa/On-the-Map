//
//  WhereViewController.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 14/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import UIKit
import MapKit

class WhereViewController: UIViewController {

  var placemark: CLPlacemark?
  var link: String?
  var mapString: String?
  
  @IBOutlet weak var locationTextfield: UITextField!
  @IBOutlet weak var linkTextfield: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func cancelAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func findOnTheMapAction(_ sender: Any) {
    
    guard let locationText = locationTextfield.text, !locationText.isEmpty else {
      showAlert("Add Location", message: "FIll the location", vc: self)
      return
    }
    
    guard let linkText = linkTextfield.text, !linkText.isEmpty else {
      showAlert("Add Location", message: "FIll the link", vc: self)
      return
    }
    
    // add placemark
    let delayInSeconds = 1.5
    let delay = delayInSeconds * Double(NSEC_PER_SEC)
    let popTime = DispatchTime(uptimeNanoseconds: UInt64(delay))
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
      let geocoder = CLGeocoder()
      do {
        geocoder.geocodeAddressString(locationText, completionHandler: { (result, error) in
          if let _ = error {
            showAlert("Location not found", message: "Could not geocode the string.", vc: self)
          }
          else if let result = result {
            if (result.isEmpty){
              showAlert("Location not found", message: "Could not geocode the string.", vc: self)
            }
            else {
              self.placemark = result[0]
              self.link = linkText
              self.mapString = locationText
              self.performSegue(withIdentifier: "LinkViewController", sender: nil)
            }
          } else {
            showAlert("Location not found", message: "Could not geocode the string.", vc: self)
          }
        })
        
      }
    }
    
  }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let vc = segue.destination as? LinkViewController {
        vc.placemark = placemark
        vc.link = link
        vc.mapString = mapString
      }
    }
 

}
