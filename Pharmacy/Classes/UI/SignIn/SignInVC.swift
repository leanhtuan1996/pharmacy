//
//  SignUpVc.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let nav = self.navigationController {
            if !nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
        
    }
    
    @IBAction func btnSignInClicked(_ sender: Any) {
        if !txtEmail.hasText {
            self.showAlert("Email can not empty", title: "Field are required", buttons: nil)
            return
        } else if !txtPassword.hasText {
            self.showAlert("Password can not empty", title: "Field are required", buttons: nil)
            return
        } else if !Utilities.validateEmail(txtEmail.text!) {
            self.showAlert("Email invalid format", title: "Field are required", buttons: nil)
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(self)
        
        guard let email = txtEmail.text, let password = txtPassword.text else {
            self.showAlert("Email or Password invalid format", title: "Fields have be not empty", buttons: nil)
            return
        }
        
        UserService.shared.signIn(email, password: password) { (user, error) in
            activityIndicatorView.stopAnimating()
            
            if let error = error {
                //Noti login failed
                self.showAlert("Sign In error: \(error)", title: "Sign in not success", buttons: nil)
                return
            }
            
            if let user = user {
                self.appDelegate.signIn_Up(user)
            }
        }
    }
}
