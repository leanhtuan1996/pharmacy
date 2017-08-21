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
        
        SignInService.shared.signIn(email: txtEmail.text!, password: txtPassword.text!) { ( isSuccess, user, error) in
            if isSuccess {                
                //Login successfully
                if let user = user {
                    user.password = self.txtPassword.text!
                    self.appDelegate.signIn_Up(user: user)
                }
                
//                self.appDelegate.signIn_Up(user: .init(email: self.txtEmail.text!, password: self.txtPassword.text!, fullName: "", address: "", phoneNumber: "", token: token!))
            } else {
                //Noti login failed
                print(error!)
            }
        }
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        appDelegate.showSignUpView()
    }

}
