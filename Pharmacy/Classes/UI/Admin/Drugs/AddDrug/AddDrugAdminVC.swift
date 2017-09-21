//
//  AddDrugAdminVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class AddDrugAdminVC: UIViewController {

    var currentDrug: DrugObject?
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var txtName: UITextField!
    var titleAction: String?
    var delegate: DrugDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        dialogView.layer.cornerRadius = 10
    }
    

    @IBAction func btnCancel(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnDone(_ sender: Any) {
        //Add drug
        if !txtName.hasText {
            self.showAlert("Fields can not empty", title: "Fields are required", buttons: nil)
            return
        }
        currentDrug = DrugObject()
        currentDrug?.name = txtName.text
        
        if let drug = currentDrug {
            self.delegate?.add(with: drug)
        }
        
        
    }
}
