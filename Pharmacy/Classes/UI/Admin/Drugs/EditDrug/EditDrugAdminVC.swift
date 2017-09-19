
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
        
        txtPrice.text = String(drug.price)
        txtHowToUse.text = drug.howToUse
        txtSideEffect.text = drug.sideEffect
        txtContraindication.text = drug.contraindication
        txtInstructions.text = drug.instructions
        txtFormula.text = drug.formula
        txtName.text = drug.name
    }
   
    @IBAction func btnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        //Add drug
        if !(txtPrice.hasText && txtHowToUse.hasText && txtSideEffect.hasText && txtContraindication.hasText && txtInstructions.hasText && txtFormula.hasText && txtName.hasText) {
            self.showAlert(message: "Fields can not empty", title: "Fields are required", buttons: nil)
            return
        }
        
        guard let priceText = txtPrice.text, let price = Int(priceText) else {
            self.showAlert(message: "Price must be a number", title: "Fields are required", buttons: nil)
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(toVC: self)
        
        guard let drug = drug else {
            return
        }
        
        let drugObject = DrugObject()
        drugObject.id = drug.id
        drugObject.name = txtName.text ?? ""
        drugObject.instructions = txtInstructions.text ?? ""
        drugObject.formula = txtFormula.text ?? ""
        drugObject.contraindication = txtContraindication.text ?? ""
        drugObject.sideEffect = txtSideEffect.text ?? ""
        drugObject.howToUse = txtHowToUse.text ?? ""
        drugObject.price = price
        
        DrugsService.shared.editDrug(drug: drugObject) { (error) in
            activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(message: error, title: "Edit drug incompleted", buttons: nil)
                return
            }
            let alertAction = UIAlertAction(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.showAlert(message: "Edit drug successfully", title: "Success", buttons: [alertAction])
        }
    }

}
