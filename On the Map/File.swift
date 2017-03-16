//
//  File.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 12/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import Foundation
import UIKit
import MapKit

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

protocol ListOfStudentsLocationsProtocol {
  func added(listOfStudentsLocationsProtocol: ListOfStudentsLocations)
}

class ListOfStudentsLocations: NSObject {
  var uniqueKeyUser: String?
  var user : Student?
  
  static let sharedInstance = ListOfStudentsLocations()
  
  private(set) var students : [Student] = [] {
    didSet {
      students = students.sorted(by: { (s1, s2) -> Bool in
        s1.studentLocation?.updatedAt?.timeIntervalSince1970 ?? 0 > s2.studentLocation?.updatedAt?.timeIntervalSince1970 ?? 0
      })
    }
  }
  
  private var observers : [ListOfStudentsLocationsProtocol] = []
  
  private override init() {
    super.init()
    refresh()
  }
  
  func addObserve(observer: ListOfStudentsLocationsProtocol) {
    observers.append(observer)
  }
  
  func addMeme(_ student: Student) {
    students.append(student)
    
    for o in observers {
      o.added(listOfStudentsLocationsProtocol: self)
    }
  }
  
  func refresh() {
    students = []
    getStudents()
  }
  
  private func getStudents() {
    
    let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt")!)
    
    request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      if error != nil { // Handle error...
        return
      }
      
      if let data = data {
        print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        
        // parse the data
        let parsedResult: [String:Any]!
        do {
          parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
          
          if let results = parsedResult["results"] as? [Dictionary<String,Any>] {
            for item in results {
              let studentLocation = StudentLocation(params: item)
              let student = Student(studentLocation: studentLocation)
              self.students.append(student)
            }
          }
          
          for o in self.observers {
            o.added(listOfStudentsLocationsProtocol: self)
          }
        } catch {
          print("Could not parse the data as JSON: '\(data)'")
          return
        }
      }
      
    }
    
    task.resume()
  }
  
  
  public func getStudent(uniqueKey: String) {
    
    var urlComponents = NSURLComponents(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
    
    urlComponents.queryItems = [
      URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(uniqueKey)\"}")
    ]
    let request = NSMutableURLRequest(url: urlComponents.url!)
    
    request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      if error != nil { // Handle error...
        return
      }
      
      if let data = data {
        print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        
        // parse the data
        let parsedResult: [String:Any]!
        do {
          parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
          
          if let results = parsedResult["results"] as? [Dictionary<String,Any>] {
            let userJson = results[0]
            let studentLocation = StudentLocation(params: userJson)
            self.user = Student(studentLocation: studentLocation)
          }
          
        } catch {
          print("Could not parse the data as JSON: '\(data)'")
          return
        }
      }
      
    }
    
    task.resume()
  }
}

extension String
{
  func toDateTime() -> Date
  {
    //Create Date Formatter
    let dateFormatter = DateFormatter()
    
    //Specify Format of String to Parse
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
    
    
    //Parse into NSDate
    let dateFromString : Date = dateFormatter.date(from: self)!
    
    //Return Parsed Date
    return dateFromString
  }
}

public func showAlert(_ title: String, message: String, vc: UIViewController) {
  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
  alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
  vc.present(alert, animated: true, completion: nil)
}
