//
//  Utils.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 16/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import Foundation
import UIKit

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
