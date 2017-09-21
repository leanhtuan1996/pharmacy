//
//  EditDrugAdminVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/21/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class EditDrugAdminVC: UIViewController {

    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var txtName: UITextField!
    var currentDrug: DrugObject?
    var delegate: DrugDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        dialogView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func btnDoneClicked(_ sender: Any) {
        //Add drug
        if !txtName.hasText {
            self.showAlert("Fields can not empty", title: "Fields are required", buttons: nil)
            return
        }
        
        if let drug = currentDrug {
            drug.name = txtName.text
            self.delegate?.edit(with: drug)
        }
    }
}
