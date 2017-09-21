//
//  ChangeInfoVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/23/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class ChangeInfoVC: UIViewController {

    @IBOutlet weak var txtCurrentPw: UITextField!
    
    @IBOutlet weak var txtFullname: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhonenumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnUpdateClicked(_ sender: Any) {
        
        //check empty
        if !(txtCurrentPw.hasText && txtFullname.hasText && txtAddress.hasText && txtPhonenumber.hasText) {
            self.showAlert("Fields can not empty", title: "Fields are required", buttons: nil)
            return
        }
        
        guard let currentPw = txtCurrentPw.text, let fullName = txtFullname.text, let phoneNumber = txtPhonenumber.text, let address = txtAddress.text else {
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        activityIndicatorView.showLoadingDialog(self)
        
        let userObject = UserObject(email: "")
        userObject.address = address
        userObject.password = currentPw
        userObject.fullName = fullName
        userObject.phoneNumber = phoneNumber
        
        UserService.shared.updateInfo(userObject) { (error) in
            activityIndicatorView.stopAnimating()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            if let error = error {
                self.showAlert(error, title: "Update information failed", buttons: nil)
                return
            }
            
            //show alert
            let alert = UIAlertController(title: "Thông báo", message: "Infomations has been updated successfully", preferredStyle: .alert)
            alert.addAction(.init(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                UserManager.shared.currentUser = userObject
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    @IBAction func btnCancelClicked(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
}
