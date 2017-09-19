//
//  AddDrugAdminVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class AddDrugAdminVC: UIViewController {

    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtHowToUse: UITextField!
    @IBOutlet weak var txtSideEffect: UITextField!
    @IBOutlet weak var txtContraindication: UITextField!
    @IBOutlet weak var txtInstructions: UITextField!
    @IBOutlet weak var txtFormula: UITextField!
    @IBOutlet weak var txtName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController {
//            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            nav.navigationBar.shadowImage = UIImage()
//            nav.navigationBar.isTranslucent = true
//            nav.view.backgroundColor = .clear
//            nav.navigationBar.tintColor = UIColor.white
//            nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            
            if nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(false, animated: true)
            } else {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
        // Do any additional setup after loading the view.
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
        let drugObject = DrugObject()
        drugObject.name = txtName.text ?? ""
        drugObject.instructions = txtInstructions.text ?? ""
        drugObject.formula = txtFormula.text ?? ""
        drugObject.contraindication = txtContraindication.text ?? ""
        drugObject.sideEffect = txtSideEffect.text ?? ""
        drugObject.howToUse = txtHowToUse.text ?? ""
        drugObject.price = price
        
        DrugsService.shared.addDrug(drug: drugObject) { (error) in
            activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(message: error, title: "Add new drug incompleted", buttons: nil)
                return
            }
            let alertAction = UIAlertAction(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.showAlert(message: "Add new drug successfully", title: "Success", buttons: [alertAction])
        }
    }
}
