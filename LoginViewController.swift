//
//  LoginViewController.swift
//  sprint2
//
//  Created by Capgemini-DA164 on 9/22/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Firebase
import CoreData
import LocalAuthentication

class LoginViewController: UIViewController {

  //MARK: Outlets
    
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //caliing authencation by by faceId function
        authenticationByFaceId()
    }
    
    //creating a function to return storyboard
    static func getVC() -> LoginViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return VC
    }
    
   // MARK: Action Button
    @IBAction func loginClick(_ sender: Any) {
        
        let email = emailTxt.text
        let emailValid = validEmailId(emailId: email!)
        
        let password = passwordTxt.text
        let passwordValid = validPassword(password: password!)
        
  /* Checking the validation of the textFields weather it empty or not and then
   checking weather the data present in core data  or not then use sign function
   of firebase to login and then save it to core data*/
        
        if let emailEmpt = emailTxt.text, !emailEmpt.isEmpty {
            if emailValid {
                if let passwordEmpt = passwordTxt.text, !passwordEmpt.isEmpty {
                    if passwordValid {
                        if entityExists(email: email!) {
                            Auth.auth().signIn(withEmail: email!, password: password!  ,completion: { (result , error) -> Void in
                                if let _error = error {
                                    print(_error.localizedDescription)
                                   // return false
                                } else {
                                    print("User logged in Suceddfully")
                                    // save to coreData
                                    self.saveCoreData()
                                    //thenn navigate to tab bar
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBar")
                                    mainTabBarController.modalPresentationStyle = .fullScreen
                                    
                                    self.present(mainTabBarController, animated: true, completion: nil)                                  //  return true
                                }
                                
                            })
                              
                        } else {
                            displayAlertMessage(messageDisplay: "email not eixst , Please SignUp")
                        }
                    } else {
                        displayAlertMessage(messageDisplay: "password not valid")
                    }
                } else {
                    displayAlertMessage(messageDisplay: "Password field is empty")
                }
            } else {
                displayAlertMessage(messageDisplay: "enter valid email")
            }
        } else {
            displayAlertMessage(messageDisplay: "email is empty")
        }
        
        
        
    }
   
    // MARK: Functionality
    func loginUser(emailId: String, password: String) {
    
        Auth.auth().signIn(withEmail: emailId, password: password, completion: { (result , error) -> Void in
            if let _error = error {
                print(_error.localizedDescription)
               // return false
            } else {
                print("User logged in Suceddfully")
                self.saveCoreData()
              //  return true
            }
            
        })
        
    }
    
    // function to save in coreData
    func saveCoreData()  {
                
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
       let context = appDe.persistentContainer.viewContext
      
       // call entity
        let entity = NSEntityDescription.entity(forEntityName: "LoginUserData", in: context)
        
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        //we add data
        
        newUser.setValue(emailTxt.text, forKey: "email")
        
        newUser.setValue(passwordTxt.text, forKey: "password")
        
        //now save the data
        
        do {
            try context.save()
            print("save")
            
        } catch  let error {
            print("error: \(error)")
        }

        
    }
    
   //Function For FaceId
    func authenticationByFaceId() {
        
        let context = LAContext()
        var eeror: NSError?
        let access = "Identify User"
        
        // creating authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &eeror){
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: access) { [weak self] pass , authencationError in
                DispatchQueue.main.async {
                    if pass {
                        self?.alertMsg(msg: "Authencation Sucessfull", title: "Sucess")
                    } else {
                        
                    }
                }
            }
        } else {
            alertMsg(msg: "No Authentication", title: "Error")
        }
        
    }
    
    func alertMsg (msg: String, title: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Function to check Email Id Exist in coreData or not
       func entityExists( email: String) -> Bool {
               guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
              
               let managedContext = appDelegate.persistentContainer.viewContext
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserData")
              fetchRequest.predicate = NSPredicate(format: "email = %@", email)
              var result: [NSManagedObject] = []
              do {
                  result = try managedContext.fetch(fetchRequest)
              } catch (let error){
                  print(error.localizedDescription)
              }
              return result.count > 0
          }
    
    
    
    //Funtion to display Alert message
     func displayAlertMessage(messageDisplay: String) {
             let alert = UIAlertController(title: "Alert", message: messageDisplay, preferredStyle: .alert)
             let okAction = UIAlertAction(title: "ok", style: .default)
             alert.addAction(okAction)
             self.present(alert, animated: true, completion: nil)
         }
    
    //Funtion to validate password
    func validPassword( password: String) -> Bool {
        let checkPassword = NSPredicate(format: "Self MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z].*[a-z].*[a-z].*[a-z])(?=.*[0-9].*[0-9].*[0-9]).{8}$")
        return checkPassword.evaluate(with: password)
    }
    
    //Function to validate EmailId
      func validEmailId(emailId: String) -> Bool {
          let checkEmail = NSPredicate(format: "self MATCHES %@","[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
          return checkEmail.evaluate(with: emailId)
      }
    
    
}
