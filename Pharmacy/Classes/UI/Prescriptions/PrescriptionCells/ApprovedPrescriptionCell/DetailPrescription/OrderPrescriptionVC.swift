//
//  OrderPrescriptionVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/17/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class OrderPrescriptionVC: UIViewController {
    
    var prescription: PrescriptionObject?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var tblDrugs: UITableView!
    @IBOutlet weak var lblTotalDrug: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tblDrugs.register(UINib(nibName: "DrugsOfOrderPrescriptionCell", bundle: nil), forCellReuseIdentifier: "DrugsOfOrderPrescriptionCell")
        tblDrugs.dataSource = self
        tblDrugs.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        lblName.text = prescription?.name ?? "Name Not Found"
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOrderClicked(_ sender: Any) {
        
    }
}

extension OrderPrescriptionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescription?.drugs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrugsOfOrderPrescriptionCell", for: indexPath) as? DrugsOfOrderPrescriptionCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = prescription?.drugs[indexPath.row].name ?? ""
        cell.lblPrice.text = String(prescription?.drugs[indexPath.row].price ?? 0)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
  
}
