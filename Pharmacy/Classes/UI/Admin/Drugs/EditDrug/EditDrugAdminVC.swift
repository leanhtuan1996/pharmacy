
//
//  EditDrugAdminVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/19/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class EditDrugAdminVC: UIViewController {
    
    var drug: DrugObject?
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtHowToUse: UITextField!
    @IBOutlet weak var txtSideEffect: UITextField!
    @IBOutlet weak var txtContraindication: UITextField!
    @IBOutlet weak var txtInstructions: UITextField!
    @IBOutlet weak var txtFormula: UITextField!
    @IBOutlet weak var txtName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let nav = self.navigationController {
            if nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(false, animated: true)
            } else {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
        
        guard let drug = drug else {
            return
        }
        txtName.text = drug.name
    }
   
    @IBAction func btnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        //Add drug
        if !txtName.hasText {
            self.showAlert("Fields can not empty", title: "Fields are required", buttons: nil)
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(self)
        
        guard let drug = drug else {
            return
        }
        
        let drugObject = DrugObject()
        drugObject.id = drug.id
        drugObject.name = txtName.text ?? ""
        
        DrugsService.shared.editDrug(drugObject) { (error) in
            activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Edit drug incompleted", buttons: nil)
                return
            }
            let alertAction = UIAlertAction(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.showAlert("Edit drug successfully", title: "Success", buttons: [alertAction])
        }
    }

}
