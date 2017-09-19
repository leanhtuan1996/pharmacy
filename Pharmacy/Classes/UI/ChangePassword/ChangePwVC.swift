//
//  ChangePwVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/23/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class ChangePwVC: UIViewController {

    @IBOutlet weak var txtOldPw: UITextField!
    @IBOutlet weak var txtNewPw: UITextField!
    @IBOutlet weak var txtConfirmPw: UITextField!
    
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
        
        //Check empty fields
        if !(txtOldPw.hasText && txtConfirmPw.hasText && txtNewPw.hasText) {
            self.showAlert(message: "Fields are required", title: "Fields have be not empty", buttons: nil)
            return
        }
        
        //check nil
        guard let oldPassword = txtOldPw.text, let newPassword = txtNewPw.text, let confirmPassword = txtConfirmPw.text else {
            return
        }
        
        //check match between newPw & confirmPw
        if newPassword != confirmPassword {
            self.showAlert(message: "Retype new password not match", title: "Error", buttons: nil)
            return
        }
        
        UpdatePwService.shared.updatePw(oldPassword: oldPassword, newPassword: newPassword, confirmPw: confirmPassword) { (error) in
            
            if let error = error {
                self.showAlert(message: error, title: "Update password error", buttons: nil)
                return
            }
            
            let action = UIAlertAction(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.showAlert(message: "Password has been updated successfully", title: "Thông báo", buttons: [action])
        }
    }
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
