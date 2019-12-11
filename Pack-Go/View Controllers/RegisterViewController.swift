//
//  RegisterViewController.swift
//  Pack-Go
//
//  Created by Lorraine Chong on 2019-12-11.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPasswordRepeat: UITextField!
    @IBOutlet var lblInvalidNotification : UILabel!
    
    @IBAction func didSubmit(sender: UIButton!){
        //Validations
        if (txtUsername.text!.count == 0 && txtPassword.text!.count == 0 && txtPasswordRepeat.text!.count == 0){
            lblInvalidNotification.text = "Please provide information about your account"

        } else if(txtUsername.text!.count == 0){
            lblInvalidNotification.text = "Please provide a username"
        } else if(txtPassword.text!.count == 0){
            lblInvalidNotification.text = "Please provide a password"
        } else if(txtPasswordRepeat.text!.count == 0){
            lblInvalidNotification.text = "Please provide your password again"
        } else {
            if(txtPassword.text! != txtPasswordRepeat.text!){
                lblInvalidNotification.text = "Password does not match"
            } else {
                // if input is valid do...
                let newUser = getUserLoginInformation(username: txtUsername.text!, password: txtPassword.text!)
                // check if username is already registered
                if(newUser.username == nil) {
                    //Create new account
                    insertUser(user: txtUsername.text!, pass: txtPassword.text!)
//                    createUser(username: txtUsername.text!, password: txtPassword.text!)
                    
                    lblInvalidNotification.text = "Successfully created an account"
                    
                    txtUsername.text = ""
                    txtPassword.text = ""
                    txtPasswordRepeat.text = ""
//                    performSegue(withIdentifier: "unwindSegueToLoginViewController", sender: nil)
                } else {
                    lblInvalidNotification.text = "Username already exists!"
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblInvalidNotification.text = ""

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
