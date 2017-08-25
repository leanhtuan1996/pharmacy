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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //get info user
        GetInformationService.shared.getInformations { (isSuccess, Data, Error) in
            if isSuccess {
                guard let user = Data else {
                    self.present(self.showAlert(message: "Data is not available"), animated: true, completion: nil)
                    return
                }
                
                self.txtAddress.text = user.address
                self.txtEmail.text = user.email
                self.txtPhoneNumber.text = user.phoneNumber
                self.txtFullname.text = user.fullName
                
            } else {
                //Show error
                guard let err = Error else {
                    self.present(self.showAlert(message: "Get failed informations"), animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.present(self.showAlert(message: err), animated: true, completion: nil)                
                self.navigationController?.popViewController(animated: true)
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
