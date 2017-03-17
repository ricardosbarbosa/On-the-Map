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

enum UdacityRequests {
  
  case students
  case student
  case login
  case logout
  case update
  case post
  
  var url : String {
    switch self {
    case .students:
      return "https://parse.udacity.com/parse/classes/StudentLocation"
    case .login :
      return "https://www.udacity.com/api/session"
    case .logout:
      return "https://www.udacity.com/api/session"
    case .update:
      return "https://parse.udacity.com/parse/classes/StudentLocation/"
    case .post:
      return "https://parse.udacity.com/parse/classes/StudentLocation)"
    default:
      return ""
    }
  }
  
  var httpMethod : String {
    switch self {
    case .login: return "POST"
    case .logout: return "DELETE"
    case .update: return "PUT"
    case .post: return "POST"
    default: return "GET"
    }
  }
}
public class Api : NSObject {
  
  private func makeRequest(udacity: UdacityRequests, params: Dictionary<String, Any>,
                           completionHandler: @escaping (Any?, Error?) -> Void) {
    
    var newParams = params
    
    
    var urlComponents = NSURLComponents(string: udacity.url)!
    if udacity == .update {
      if let key = newParams["objectId"] as? String {
        urlComponents = NSURLComponents(string: udacity.url+key)!
        newParams.removeValue(forKey: "objectId")
      }
    }
    
    let request = NSMutableURLRequest(url: urlComponents.url!)
    request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    if let applicationJson = newParams["Content-Type"] as? String{
      request.addValue(applicationJson, forHTTPHeaderField: "Content-Type")
      newParams.removeValue(forKey: "Content-Type")
    }
    
    if let applicationJson = newParams["Accept"] as? String{
      request.addValue(applicationJson, forHTTPHeaderField: "Accept")
      newParams.removeValue(forKey: "Accept")
    }
    
    if let httpBody = newParams["httpBody"] as? Data {
      request.httpBody = httpBody
      newParams.removeValue(forKey: "httpBody")
    }
    
    var queryItens : [URLQueryItem] = []
    for key in newParams.keys {
      if let value = params[key] as? String {
        queryItens.append(URLQueryItem(name: key, value: value))
      }
    }
    urlComponents.queryItems = queryItens
    
    request.httpMethod = udacity.httpMethod
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      if error != nil { // Handle error...
        completionHandler(nil, error)
        return
      }
      
      if let data = data {
        print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        
        // parse the data
        let parsedResult: [String:Any]?
        do {
          parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary
          
          completionHandler(parsedResult, error)
          
        } catch let e {
          print("Could not parse the data as JSON: '\(data)'")
          completionHandler(nil, e)
          return
        }
      }
    }
    
    task.resume()
  }
  
  public func post(params: Dictionary<String,Any>, completionHandler: @escaping (Any?, Error?) -> Void) {
    guard
      let uniqueKey = params["uniqueKey"],
      let firstName = params["firstName"],
      let lastName = params["lastName"],
      let mapString = params["mapString"],
      let link = params["link"],
      let latitude = params["latitude"],
      let longitude = params["longitude"]
      else {
        return
    }
    var newParams = Dictionary<String,Any>()
    newParams["Content-Type"] = "application/json"
    newParams["httpBody"] = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
    makeRequest(udacity: .post, params: newParams) { (result, error) in
      completionHandler(result, error)
    }
  }
  
  public func update(params: Dictionary<String,Any>, completionHandler: @escaping (_ updatedAt: String?, Error?) -> Void) {
    
    
    guard
      let uniqueKey = params["uniqueKey"],
      let firstName = params["firstName"],
      let lastName = params["lastName"],
      let mapString = params["mapString"],
      let link = params["link"],
      let latitude = params["latitude"],
      let longitude = params["longitude"]
      else {
        return
    }

    var newParams = Dictionary<String,Any>()
    newParams["objectId"] = params["objectId"]
    newParams["Content-Type"] = "application/json"
    newParams["httpBody"] =  "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
    makeRequest(udacity: .update, params: newParams) { (data, error) in
      if let error = error {
        completionHandler(nil, error)
      }
      if let data = data as? Dictionary<String, Any>{
        let date  = data["updatedAt"] as? String
        completionHandler(date, error)
      }
      else {
         completionHandler(nil, error)
      }
    }
  }
  
  public func getStudents(completionHandler: @escaping (Any?, Error?) -> Void) {
    var params : Dictionary<String,String> = Dictionary()
    params["limit"] = "100"
    params["order"] = "-updatedAt"
    makeRequest(udacity: .students, params: params) { (result, error) in
      completionHandler(result, error)
    }
  }
  
  
  public func getStudent(uniqueKey: String, completionHandler: @escaping (Any?, Error?) -> Void) {
    var params : Dictionary<String,String> = Dictionary()
    params["where"] = "{\"uniqueKey\":\"\(uniqueKey)\"}"
    
    makeRequest(udacity: .students, params: params) { (result, error) in
      completionHandler(result, error)
    }
  }
  
  public func logout() {
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
  
  public func login(email:String, password: String,
                    completionHandler: @escaping (String?, String?, Error?) -> Void) {
    
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      if error != nil { // Handle error…
        completionHandler(nil, nil, error)
        return
      }
      if let data = data  {
        let range = Range(5 ..< data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        let string = String(data: newData, encoding: String.Encoding.utf8)!
        print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
        
        if (string.contains("error")) {
          completionHandler(nil, string, error)
        }
        else {
          
          let parsedResult = try! JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:Any]
          let account = parsedResult["account"] as! [String:Any]
          let key = account["key"] as? String
          
          completionHandler(key, string as String, error)
        }

      }
      
    }
    task.resume()
   
  }
}


