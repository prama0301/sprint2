//
//  SignUpViewController.swift
//  
//
//  Created by Capgemini-DA164 on 9/21/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
//import XCTest

class SignUpViewController: UIViewController {

  //  @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
   // @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
  //  @IBOutlet weak var conformPasswordTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let email: String = emailTxt.text!
      //  let name: String = nameTxt.text!
     //   let mobile: String = mobileTxt.text!
        let password: String = passwordTxt.text!
      //  let conformPassword: String = conformPasswordTxt.text!
        
       registerUser(emailID: email, password: password)
        
        
    }
    
    func registerUser( emailID: String, password: String) {
        
        Auth.auth().createUser(withEmail: emailID, password: password , completion: {(result, error) -> Void in
            if let _error = error {
                print(_error.localizedDescription)
            } else {
                print("sucessfull")
                
            }
        })
    }

}
