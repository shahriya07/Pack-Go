//
//  LoginViewController.swift
//  Pack-Go
//
//  Created by Lorraine Chong on 2019-12-11.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var lblInvalidNotification : UILabel!
    
    @IBAction func login(sender: UIButton!){
        if (txtUsername.text!.count == 0 && txtPassword.text!.count == 0){
            lblInvalidNotification.text = "Please provide username and password"
        } else if(txtUsername.text!.count == 0){
            lblInvalidNotification.text = "Please provide a username"
        } else if(txtPassword.text!.count == 0){
            lblInvalidNotification.text = "Please provide a password"
        } else {
            let user = getUserLoginInformation(username: txtUsername.text!, password: txtPassword.text!)
            if(user.username == nil){
                lblInvalidNotification.text = "Invalid username or password"
            } else {
                if (user.password == txtPassword.text!){
                    UserDefaults.standard.set(user.username, forKey: "loggedUser")
                    txtUsername.text = ""
                    txtPassword.text = ""
                    performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    lblInvalidNotification.text = "Invalid username or password"
                    txtUsername.text = ""
                    txtPassword.text = ""
                }
            }
        }
    }
    
    @IBAction func unwindToLoginVC(sender: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblInvalidNotification.text = ""
        // NOT PRIORITY ***
        //IF Account is already logged in, performSegue to next page
//        let user = getUserLoginInformation(username: "usernameAlreadyLoggedIn", password: "optional?")
        //ELSE ask user to login with their credentials (do nothing)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let username = UserDefaults.standard.object(forKey: "loggedUser") ?? ""
        if ((username as! String).count > 0){
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
    }
}
