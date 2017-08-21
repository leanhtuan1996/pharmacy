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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSignInClicked(_ sender: Any) {
        if !txtEmail.hasText {
            present(showAlert(message: "Email can not empty"), animated: true, completion: nil)
            return
        } else if !txtPassword.hasText {
            present(showAlert(message: "Password can not empty"), animated: true, completion: nil)
            return
        } else if !Utilities.validateEmail(candidate: txtEmail.text!) {
            present(showAlert(message: "Email invalid format"), animated: true, completion: nil)
            return
        }
        
        SignInService.shared.signIn(email: txtEmail.text!, password: txtPassword.text!) { ( isSuccess, user, error) in
            if isSuccess {                
                //Login successfully
                if let user = user {
                    user.password = self.txtPassword.text!
                    self.appDelegate.signIn_Up(user: user)
                }
            } else {
                //Noti login failed
                self.present(self.showAlert(message: error!), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        appDelegate.showSignUpView()
    }
}

extension SignInVC {
    func showAlert(message:String) -> UIAlertController {
        let alert:UIAlertController = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        return alert
    }
}
