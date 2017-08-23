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
            present(showAlert(message: "Fields are required"), animated: true, completion: nil)
            return
        }
        
        //check nil
        guard let oldPassword = txtOldPw.text, let newPassword = txtNewPw.text, let confirmPassword = txtConfirmPw.text else {
            return
        }
        
        //check match between newPw & confirmPw
        if newPassword != confirmPassword {
            present(showAlert(message: "Retype new password not match"), animated: true, completion: nil)
            return
        }
        
        UpdatePwService.shared.updatePw(oldPassword: oldPassword, newPassword: newPassword, confirmPw: confirmPassword) { (isSuccess, error) in
            if isSuccess {
                //Show Alert 
                
                let alert = UIAlertController(title: "Thông báo", message: "Password has been updated successfully", preferredStyle: .alert)
                alert.addAction(.init(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                //Show error                
                guard let err = error else {
                    self.present(self.showAlert(message: "Password update failed"), animated: true, completion: nil)
                    return
                }
                self.present(self.showAlert(message: err), animated: true, completion: nil)
            }
        }
        
        
    }
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
}
