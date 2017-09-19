//
//  GetInformationsVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/25/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class GetInformationsVC: UIViewController {
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtFullname: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtPhoneNumber: UILabel!
    @IBOutlet weak var imgAva: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        imgAva.layer.cornerRadius = 50
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let nav = self.navigationController {
            if !nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
        
        //get info user
        GetInformationService.shared.getInformations { (user, error) in
            
            if let error = error {
                self.showAlert(message: error, title: "Get informations error", buttons: nil)
                //self.present(self.showAlert(message: error), animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                guard let user = user else {
                    self.showAlert(message: "Data is not available", title: "Get information failed", buttons: nil)
                    return
                }
                
                self.txtAddress.text = user.address
                self.txtEmail.text = user.email
                self.txtPhoneNumber.text = user.phoneNumber
                self.txtFullname.text = user.fullName
                UserManager.shared.currentUser = user
            }
        }
    }

    @IBAction func btnUpdateClicked(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "changeInfoVC") as? ChangeInfoVC else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
