//
//  SignUpVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // - MARK: SIGN UP ACTION
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        if !txtEmail.hasText {
            present(showAlert(message: "Email can not empty"), animated: true, completion: nil)
            return
        } else if !txtPassword.hasText {
            present(showAlert(message: "Password can not empty"), animated: true, completion: nil)
            return
        } else if txtPassword.text! != txtRePassword.text! {
            present(showAlert(message: "Confirm password not correct"), animated: true, completion: nil)
            return
        } else if !Utilities.validateEmail(candidate: txtEmail.text!) {
            present(showAlert(message: "Email invalid format"), animated: true, completion: nil)
            return
        } else if !txtFullName.hasText {
            present(showAlert(message: "Fullname can not empty"), animated: true, completion: nil)
            return
        } else if !txtAddress.hasText {
            present(showAlert(message: "Address can not empty"), animated: true, completion: nil)
            return
        } else if !txtPhoneNumber.hasText {
            present(showAlert(message: "Phone number can not empty"), animated: true, completion: nil)
            return
        }
        
        let userObject = UserObject(email: txtEmail.text!, password: txtPassword.text!, fullName: txtFullName.text!, address: txtAddress.text!, phoneNumber: txtPhoneNumber.text!)
        
        SignUpService.shared.signUp(user: userObject) { (isSuccess, user, error) in
            if isSuccess {
                
                if let user = user {
                    user.password = self.txtPassword.text!
                    self.appDelegate.signIn_Up(user: user)
                } else {
                    print("Invalid User")
                }
                
            } else {
                print(error!)
            }
        }
    }

    @IBAction func btnCancelClicked(_ sender: Any) {
        appDelegate.showSignInView()
    }
    
    func showAlert(message:String) -> UIAlertController {
        let alert:UIAlertController = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        return alert
    }
    
}
