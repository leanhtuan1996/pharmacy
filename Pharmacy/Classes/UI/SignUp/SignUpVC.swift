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
    
    override func viewWillAppear(_ animated: Bool) {
                
        if let nav = self.navigationController {
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.view.backgroundColor = .clear
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            
            if nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(false, animated: true)
            } else {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
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
        
        guard let email = txtEmail.text, let password = txtPassword.text, let fullName = txtFullName.text, let address = txtAddress.text, let phoneNumber = txtPhoneNumber.text else {
            present(showAlert(message: "Fields can not empty"), animated: true, completion: nil)
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.blue
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.bounds
        activityIndicatorView.center = self.view.center
        activityIndicatorView.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
        activityIndicatorView.startAnimating()
        
        let userObject = UserObject(email: email, password: password, fullName: fullName, address: address, phoneNumber: phoneNumber)
        
        SignIn_UpService.shared.signUp(user: userObject) { (user, error) in
            activityIndicatorView.stopAnimating()
            
            if let error = error {
                self.present(self.showAlert(message: error), animated: true, completion: nil)
                return
            }
            
            if let user = user {
                self.appDelegate.signIn_Up(user: user)
            } else {
                print("Invalid User")
            }
        }
    }

    @IBAction func btnCancelClicked(_ sender: Any) {
        appDelegate.showSignInView()
    }
    
//    func showAlert(message:String) -> UIAlertController {
//        let alert:UIAlertController = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
//        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
//        return alert
//    }
    
}
