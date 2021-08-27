//
//  ViewController.swift
//  NoteLocationApp
//
//  Created by Alican Kurt on 26.08.2021.
//

import UIKit
import Parse

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != ""{
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { user , error  in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Login Error")
                }else{
                    // Segue
                    self.performSegue(withIdentifier: "toLocationsVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(title: "Error", message: "username or password is empty!")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != ""{
            
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { success , error in
                if error != nil{
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Sign Up Error")
                }else{
                    // Segue
                    self.performSegue(withIdentifier: "toLocationsVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(title: "Error", message: "Username or Password Empty")
        }
        
    }
    
    
    
    // ALERT
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

