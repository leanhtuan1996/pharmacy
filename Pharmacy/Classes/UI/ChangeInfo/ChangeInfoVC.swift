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
            present(showAlert(message: "Fields can not empty"), animated: true, completion: nil)
            return
        }
        
        let currentPw = txtCurrentPw.text!, fullName = txtFullname.text!, phoneNumber = txtPhonenumber.text!, address = txtAddress.text!
        
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.blue
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.bounds
        activityIndicatorView.center = self.view.center
        activityIndicatorView.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        activityIndicatorView.startAnimating()
        
        //print("CurrentPW: \(currentPw), fullName: \(fullName), phone: \(phoneNumber), address: \(address)")
        
        let userObject = UserObject(email: "", password: currentPw, fullName: fullName, address: address, phoneNumber: phoneNumber)
        
        UpdateInfoService.shared.updateInfo(user: userObject) { (isSuccess, error) in
            activityIndicatorView.stopAnimating()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            if isSuccess {
                
                //show alert
                let alert = UIAlertController(title: "Thông báo", message: "Infomations has been updated successfully", preferredStyle: .alert)
                alert.addAction(.init(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                    UserManager.shared.currentUser = userObject
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                //Show error
                guard let err = error else {
                    self.present(self.showAlert(message: "Update failed informations"), animated: true, completion: nil)
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
