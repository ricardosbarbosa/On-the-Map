//
//  File.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 16/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import Foundation

protocol ListOfStudentsLocationsProtocol {
  func added(listOfStudentsLocationsProtocol: ListOfStudentsLocations)
  func errorDownloading()
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
    refresh { (result, error) in
      if error != nil {
        for o in self.observers {
          o.errorDownloading()
        }
      }
    }
  }
  
  func addObserve(observer: ListOfStudentsLocationsProtocol) {
    observers.append(observer)
  }
  
  func refresh(completionHandler: @escaping (Any?, Error?) -> Void) {
    students = []
    Api().getStudents { (result, error) in
      if let error = error {
        completionHandler(result, error)
        return
      }
      
      if let result = result as? [String:Any] {
        
        if let studentsJson = result["results"] as? [Dictionary<String,Any>] {
          for item in studentsJson {
            let studentLocation = StudentLocation(params: item)
            let student = Student(studentLocation: studentLocation)
            self.students.append(student)
          }
          
          for o in self.observers {
            o.added(listOfStudentsLocationsProtocol: self)
          }
        }
        
      }
      
      completionHandler(result, error)
    }
  }
  
}
