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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        let userobject = UserObject(email: txtEmail.text!, password: txtPassword.text!, fullName: txtFullName.text!, address: txtAddress.text!, phoneNumber: txtPhoneNumber.text!, token: "")
        
        SignUpService.shared.signUp(user: userobject) { (isSuccess, token, error) in
            if isSuccess {
                userobject.token = token!
                self.appDelegate.signIn_Up(user: userobject)
                //print(token!)
            } else {
                print(error!)
            }
        }
    }

    @IBAction func btnCancelClicked(_ sender: Any) {
        appDelegate.showSignInView()
    }
}
