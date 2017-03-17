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
    
    guard let email = emailTextfield.text else {
      showAlert("Alert", message: "Email is required", vc: self)
      return
    }
    guard let password = passwordTextfield.text else {
      showAlert("Alert", message: "Password is required", vc: self)
      return
    }
    Api().login(email: email, password: password) { (key, stringData, error) in
      if let error = error {
        showAlert("Error", message: error.localizedDescription, vc: self)
      }
      
      if let string = stringData {
        if (string.contains("error")) {
          showAlert("Error", message: string, vc: self)
        }
      }
      
      if let key = key {
        self.saveUser(userKey: key)
        self.performSegue(withIdentifier: "TabViewController", sender: nil)
      }
      
    }
    
  }
  
  private func saveUser(userKey: String) {
    Api().getStudent(uniqueKey: userKey) { (result, error) in
      if let result = result as? [String:Any] {
        if let results = result["results"] as? [Dictionary<String,Any>] {
          let userJson = results[0]
          let studentLocation = StudentLocation(params: userJson)
          ListOfStudentsLocations.sharedInstance.user = Student(studentLocation: studentLocation)
        }
      }
    }
  }
  
  @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    if segue.identifier == "unwindToMenuWithSegue" {
      Api().logout()
    }
  }
  
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
