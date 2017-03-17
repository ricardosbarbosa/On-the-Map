//
//  File2.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 16/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import Foundation
import MapKit

class Student: NSObject, MKAnnotation{
  var studentLocation: StudentLocation?
  
  convenience init(studentLocation: StudentLocation) {
    self.init()
    self.studentLocation = studentLocation
  }
  
  public var coordinate: CLLocationCoordinate2D {
    get {
      return CLLocationCoordinate2DMake(self.studentLocation?.latitude ?? 0 , self.studentLocation?.longitude ?? 0)
    }
    set {
      self.studentLocation?.latitude = newValue.latitude
      self.studentLocation?.longitude = newValue.longitude
    }
  }
  
  var title: String? {
    get{
      return "\(self.studentLocation?.firstName ?? "") \(self.studentLocation?.lastName ?? "")"
    }
  }
  
  var subtitle: String? {
    get {
      return self.studentLocation?.mediaURL
    }
  }
}
