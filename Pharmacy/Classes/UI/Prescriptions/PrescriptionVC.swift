//
//  PrescriptionVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/13/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PrescriptionVC: UIViewController {

    @IBOutlet weak var tblPrescriptions: UITableView!
    @IBOutlet weak var tabControl: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var prescriptionsArray: [PrescriptionObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPrescriptions.dataSource = self
        tblPrescriptions.delegate = self
        tblPrescriptions.rowHeight = UITableViewAutomaticDimension
        tabControl.layer.cornerRadius = 15
        tabControl.clipsToBounds = true
        txtSearch.layer.cornerRadius = 15
        tblPrescriptions.register(UINib(nibName: "PrescriptionCell", bundle: nil), forCellReuseIdentifier: "PrescriptionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let nav = self.navigationController {
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.view.backgroundColor = .clear
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
            
            if !nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
        loadAllPrescriptions()
    }
    //Get all prescriptions in NSUSERDEFAULTS
    func loadAllPrescriptions() {
        //Get all presciptions from this manager
        PrescriptionManager.shared.getAllPrescription { (prescription, error) in
            //if error
            if let err = error {
                print(err)
                return
            } else {
                if let preObject = prescription {
                    self.prescriptionsArray = preObject
                    self.tblPrescriptions.reloadData()
                }
            }
        }
    }

    
    @IBAction func btnAddPrescriptionClicked(_ sender: Any) {
        if let nav = self.navigationController {
            if let sb = storyboard?.instantiateViewController(withIdentifier: "AddPrescriptionVC") as? AddPrescriptionVC {
                nav.pushViewController(sb, animated: true)
            }
        }
    }

}

extension PrescriptionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescriptionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell", for: indexPath) as? PrescriptionCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = prescriptionsArray[indexPath.row].name
        cell.lblTotalDrugs.text = String(prescriptionsArray[indexPath.row].drugs.count)
        cell.lblTotalPrice.text = String(prescriptionsArray[indexPath.row].totalPrice) + " VND"
        cell.lblStatus.text = prescriptionsArray[indexPath.row].status.rawValue
        cell.lblDateCreated.text = prescriptionsArray[indexPath.row].dateCreate
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
