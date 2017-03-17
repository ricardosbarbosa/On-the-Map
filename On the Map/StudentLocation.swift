//
//  File2.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 16/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import Foundation

struct StudentLocation {
  var objectId : String?
  var uniqueKey : String?
  var firstName : String?
  var lastName : String?
  var mapString : String?
  var mediaURL : String?
  var latitude : Double?
  var longitude : Double?
  var createdAt: Date?
  var updatedAt: Date?
  
  init(params: Dictionary<String, Any>) {
    objectId = params["objectId"] as? String
    uniqueKey = params["uniqueKey"] as? String
    firstName = params["firstName"] as? String
    lastName = params["lastName"] as? String
    mapString = params["mapString"] as? String
    mediaURL = params["mediaURL"] as? String
    latitude = params["latitude"] as? Double
    longitude = params["longitude"] as? Double
    if let date = params["createdAt"] as? String {
      createdAt = date.toDateTime()
    }
    if let date = params["updatedAt"] as? String {
      updatedAt = date.toDateTime()
    }
  }
		
}
