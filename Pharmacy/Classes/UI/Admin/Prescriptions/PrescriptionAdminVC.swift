//
//  PrescriptionAdminVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PrescriptionAdminVC: UIViewController {

    var prescriptions: [PrescriptionObject] = []
    @IBOutlet weak var tblPrescriptions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblPrescriptions.register(UINib(nibName: "PrescriptionsAdminCell", bundle: nil), forCellReuseIdentifier: "PrescriptionsAdminCell")
        tblPrescriptions.delegate = self
        tblPrescriptions.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllPrescriptionsFromService()
    }
    
    func getAllPrescriptionsFromService() {
        
        //Get all prescriptions of user from Service
        PrescriptionService.shared.getListPrescriptions { (prescriptions, error) in
            
            self.prescriptions = []
            
            if let error = error {
                print("GET ALL PRESCRIPTION FROM SERVICE NOT COMPLETE WITH ERROR: \(error)")
                return
            }
            
            guard let prescriptions = prescriptions else {
                print("GET ALL PRESCRIPTION FROM SERVICE NOT COMPLETE WITH ERROR")
                return
            }
            
            for prescription in prescriptions {
                if let status = prescription.status {
                    switch status {
                    //pending
                    case .pending :
                        self.prescriptions.append(prescription)
                    default:
                        break
                    }
                }
                
                self.tblPrescriptions.reloadData()
            }
        }
    }
   
}

extension PrescriptionAdminVC: UITableViewDelegate, UITableViewDataSource, PrescriptionReviewHandler {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionsAdminCell", for: indexPath) as? PrescriptionsAdminCell else {
            return UITableViewCell()
        }
        
        cell.prescription = prescriptions[indexPath.row]
        cell.lblName.text = prescriptions[indexPath.row].name
        cell.lblDateCreated.text = prescriptions[indexPath.row].dateCreate
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func reject(withId id: Int) {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(self)
        PrescriptionService.shared.rejectPrescription(withId: id) { (error) in
            activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert("Reject incomplete with error: \(error)", title: "Error", buttons: nil)
                return
            }
            
            self.deleteElementInArray(with: id)
            self.deleteCellInTable(with: id)
            
        }
    }
    
    func accept(withId id: Int) {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(self)
        PrescriptionService.shared.acceptPrescription(withId: id) { (error) in
            activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert("Reject incomplete with error: \(error)", title: "Error", buttons: nil)
                return
            }
            self.deleteElementInArray(with: id)
            self.deleteCellInTable(with: id)
            
        }
    }
    
    func deleteCellInTable(with index: Int) {
        if let index = prescriptions.index(where: { (p) -> Bool in
            return index == p.id
        }) {
            tblPrescriptions.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: UITableViewRowAnimation.fade)
        }
        
        
    }
    
    func deleteElementInArray(with index: Int) {
        if let index = prescriptions.index(where: { (p) -> Bool in
            return index == p.id
        }) {
            prescriptions.remove(at: index)
            tblPrescriptions.reloadData()
        }
    }
    
}

protocol PrescriptionReviewHandler {
    func reject(withId id: Int) -> Void
    func accept(withId id: Int) -> Void
}

