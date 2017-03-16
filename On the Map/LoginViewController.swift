//
//  ViewController.swift
//  On the Map
//
//  Created by Ricardo Barbosa on 12/03/17.
//  Copyright © 2017 Ricardo Barbosa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {
    subscribeToKeyboardNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    unsubscribeFromKeyboardNotifications()
  }
  
  //MARK - Cuida do teclado
  
  func getKeyboardHeight(_ notification:Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.cgRectValue.height
  }
  
  func keyboardWillShow(_ notification:Notification) {
    view.frame.origin.y = 0 - getKeyboardHeight(notification)
  }
  
  func keyboardWillHide(_ notification:Notification) {
    view.frame.origin.y = 0
  }
  
  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  func unsubscribeFromKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }

  
  @IBAction func loginAction(_ sender: Any) {
    emailTextfield.resignFirstResponder()
    passwordTextfield.resignFirstResponder()
    
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    guard let email = emailTextfield.text else {
      showAlert("Alert", message: "Email is required", vc: self)
      return
    }
    guard let password = passwordTextfield.text else {
      showAlert("Alert", message: "Password is required", vc: self)
      return
    }
    
    request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      if error != nil { // Handle error…
        showAlert("Error", message: error!.localizedDescription, vc: self)
        return
      }
      let range = Range(5 ..< data!.count)
      let newData = data?.subdata(in: range) /* subset response data! */
      let string = NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!
      print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
      
      if (string.contains("error")) {
        showAlert("Error", message: string as String, vc: self)
      }
      else {
        
        let parsedResult = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:Any]
        let session = parsedResult["session"] as! [String:Any]
        let account = parsedResult["account"] as! [String:Any]
        
        self.saveUser(userKey: account["key"] as! String)
        self.performSegue(withIdentifier: "TabViewController", sender: nil)
      }
    }
    task.resume()
  }
  
  private func saveUser(userKey: String) {
    ListOfStudentsLocations.sharedInstance.getStudent(uniqueKey: userKey)
  }
  
  @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let vc = segue.destination as! TabViewController
    
  }
  
}

extension LoginViewController : UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

}
