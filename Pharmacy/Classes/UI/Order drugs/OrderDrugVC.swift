//
//  OrderDrug.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class OrderDrugVC: UIViewController {
    @IBOutlet weak var tblPrescriptions: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tblPrescriptions.dataSource = self
        tblPrescriptions.delegate = self
        tblPrescriptions.register(UINib(nibName: "PrescriptionCell", bundle: nil), forCellReuseIdentifier: "PrescriptionCell")
        
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OrderDrugVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblPrescriptions.dequeueReusableCell(withIdentifier: "PrescriptionCell", for: indexPath) as? PrescriptionCell else {
            return UITableViewCell()
        }
        cell.txtSTT.text = String(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
   
    
}
