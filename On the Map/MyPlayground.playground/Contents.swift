

import UIKit
import PlaygroundSupport

let strDate = "2015-11-01T10:11:10.0Z"
let strDat2 = "2017-03-14T17:35:52.628Z"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
let date = dateFormatter.date(from:strDat2)
print("date: \(date!)")

// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

public let PARSE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
public let REST_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

//let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//
//request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue(REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//  if error != nil { // Handle error...
//    return
//  }
//  print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}
//
//task.resume()


//let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/xktUamDHQY"
//let url = URL(string: urlString)
//let request = NSMutableURLRequest(url: url!)
//request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue(REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
//
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//  if error != nil { // Handle error
//    return
//  }
//  print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()

//let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//request.httpMethod = "POST"
//request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue(REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//  if error != nil { // Handle error…
//    return
//  }
//  print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()
//
//let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//request.httpMethod = "POST"
//request.addValue("application/json", forHTTPHeaderField: "Accept")
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"udacity\": {\"username\": \"rbrico@gmail.com\", \"password\": \"ricardo23\"}}".data(using: String.Encoding.utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//  if error != nil { // Handle error…
//    return
//  }
//  let range = Range(5 ..< data!.count)
//  let newData = data?.subdata(in: range) /* subset response data! */
//  print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()


//let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//request.httpMethod = "DELETE"
//var xsrfCookie: HTTPCookie? = nil
//let sharedCookieStorage = HTTPCookieStorage.shared
//for cookie in sharedCookieStorage.cookies! {
//  if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
//}
//if let xsrfCookie = xsrfCookie {
//  request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//}
//let session = URLSession.shared
//let task = session.dataTask(with: request as URLRequest) { data, response, error in
//  if error != nil { // Handle error…
//    return
//  }
//  let range = Range(5 ..< data!.count)
//  let newData = data?.subdata(in: range) /* subset response data! */
//  print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//}
//task.resume()
