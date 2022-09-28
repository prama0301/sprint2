//
//  SignUpPageViewController.swift
//  sprint2
//
//  Created by Capgemini-DA164 on 9/21/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import CoreData
class SignUpPageViewController: UIViewController {

    // MARK: Outlets
      @IBOutlet weak var nameTxt: UITextField!
      
      @IBOutlet weak var emailTxt: UITextField!
      
      @IBOutlet weak var mobileTxt: UITextField!
      
      @IBOutlet weak var passwordTxt: UITextField!
      
      @IBOutlet weak var conformPasswordTxt: UITextField!
   
    
    static func getSignUpVC() -> SignUpPageViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "SignUpPageViewController") as! SignUpPageViewController
        return VC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
    }
    
    // MARK: SignUp Button Action
    @IBAction func signUpButton(_ sender: Any) {
        
    // call validation function
       validateTextField()
        
    }
 
    //Created a funtion to validate textFeilds
    func validateTextField() {
        
        
        let email = emailTxt.text
        //for email Validation
        let emailValid = validEmailId(emailId: email!)
        
        let mobile = mobileTxt.text
        // for mobile validation
        let mobileValid = validMobile(mobile: mobile!)
        
        let password = passwordTxt.text
        // for Password validation
        let passwordValid = validPassword(password: password!)
        
        let conformPassword = conformPasswordTxt.text
        // for Conforn Password
        let ConformPasswordValid = validConfirmPassword(password: password!, confirmPassword: conformPassword!)
    
        /* Here we check that the textFields are emply or not and textfields are
        valid or not then will save to firebase data Storage and save it to coreData
        */
                
        if let nameEmpt = nameTxt.text, !nameEmpt.isEmpty {
            if let emailEmpt = emailTxt.text, !emailEmpt.isEmpty {
                if emailValid {
                    if let mobileEmpt = mobileTxt.text, !mobileEmpt.isEmpty {
                        if mobileValid {
                            if let passwordEmpt = passwordTxt.text, !passwordEmpt.isEmpty {
                                if passwordValid {
                                    if let conformPasswordEmpt = conformPasswordTxt.text, !conformPasswordEmpt.isEmpty {
                                        if ConformPasswordValid {
                                            let email: String = emailTxt.text!
                                          
                                             let password: String = passwordTxt.text!
                                           
                                             
                                            registerUser(emailID: email, password: password)
                                        } else {
                                            displayAlertMessage(messageDisplay: "Password is not same")
                                        }
                                    } else {
                                        displayAlertMessage(messageDisplay: "Enter conform Password")
                                    }
                                } else {
                                    displayAlertMessage(messageDisplay: "Enter valid password")
                                }
                            } else {
                                displayAlertMessage(messageDisplay: "Password field is empty")
                            }
                        } else {
                            displayAlertMessage(messageDisplay: "mobile no is not valid")
                        }
                    } else {
                        displayAlertMessage(messageDisplay: "mobile is empty")
                    }
                } else {
                    displayAlertMessage(messageDisplay: "Email is not valid")
                }
            } else {
                displayAlertMessage(messageDisplay: "Email is empty")
            }
        } else{
            displayAlertMessage(messageDisplay: "Name is empty")
        }
    }
    
    //Function to check Email Id Exist in coreData or not
       func entityExists( email: String) -> Bool {
               guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
              
               let managedContext = appDelegate.persistentContainer.viewContext
           //creating Fetch request
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
    
 //Function to register user to fireBase
    func registerUser( emailID: String, password: String) {
        
        let email: String = emailTxt.text!
        let name: String = nameTxt.text!
        let mobile: String = mobileTxt.text!
     
        //calling create user function to save user Detail
        Auth.auth().createUser(withEmail: emailID, password: password , completion: {(result, error) -> Void in
            if let _error = error {
                print(_error.localizedDescription)
            } else {
                print("sucessfull")
                
                //create firebase storage to store data
                let db = Firestore.firestore()
                
                db.collection("Users").addDocument(data: ["Email": email, "Name": name, "Number": mobile, "uid": result!.user.uid]) { (error) in
                    if error != nil {
                        print("error")
                    }
                }
                // call save to core data function
                self.saveCoreData()
                print("save to core data")
            }
        })
    }
    
    //Save Data in CoreData
    func saveCoreData() {
                
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
       let context = appDe.persistentContainer.viewContext
      
       // call entity data
        let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
        
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        //we add data to entity
        newUser.setValue(nameTxt.text, forKey: "name")
        newUser.setValue(emailTxt.text, forKey: "email")
        newUser.setValue(mobileTxt.text, forKey: "number")
        newUser.setValue(passwordTxt.text, forKey: "password")
        
        //now save the data and navigate
        
        do {
            try context.save()
            print("save")
            
            //navigation
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "navigation")
            mainTabBarController.modalPresentationStyle = .fullScreen
            
            self.present(mainTabBarController, animated: true, completion: nil)
            print("navigate")
            
        } catch  let error {
            print("error: \(error)")
        }

        
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
     
    //Function to Validate Mobile number
     func validMobile( mobile: String) -> Bool {
         let checkMobile = NSPredicate(format: "self MATCHES %@", "^[0-9]{10}$")
         return checkMobile.evaluate(with: mobile)
     }
     
   // Function to check conform Password
     func validConfirmPassword( password: String , confirmPassword: String) -> Bool {
         if password == confirmPassword {
             return true
         } else {
             return false
         }
     }
     
   //Function to validate EmailId
     func validEmailId(emailId: String) -> Bool {
         let checkEmail = NSPredicate(format: "self MATCHES %@","[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
         return checkEmail.evaluate(with: emailId)
     }
    
}
