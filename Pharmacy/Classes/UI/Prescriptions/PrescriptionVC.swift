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
    @IBOutlet weak var btnCreatedPre: UIButton!
    @IBOutlet weak var btnRequestedPre: UIButton!
    @IBOutlet weak var btnRejectedPre: UIButton!
    @IBOutlet weak var btnOrderedPre: UIButton!
    
    var selectionType: Status = .creating
    
    var prescriptionsCreated: [PrescriptionObject] = []
    var prescriptionsPending: [PrescriptionObject] = []
    var prescriptionsRejected: [PrescriptionObject] = []
    var prescriptionsOrder: [PrescriptionObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaults.standard.removeObject(forKey: "Prescriptions")
        tblPrescriptions.dataSource = self
        tblPrescriptions.delegate = self
        //tblPrescriptions.rowHeight = UITableViewAutomaticDimension
        tabControl.layer.cornerRadius = 15
        tabControl.clipsToBounds = true
        txtSearch.layer.cornerRadius = 15
        tblPrescriptions.register(UINib(nibName: "PendingPrescriptionCell", bundle: nil), forCellReuseIdentifier: "PendingPrescriptionCell")
        tblPrescriptions.register(UINib(nibName: "SubmitPrescriptionCell", bundle: nil), forCellReuseIdentifier: "SubmitPrescriptionCell")
        tblPrescriptions.register(UINib(nibName: "RejectedPrescriptionCell", bundle: nil), forCellReuseIdentifier: "RejectedPrescriptionCell")
        tblPrescriptions.register(UINib(nibName: "ApprovedPrescriptionCell", bundle: nil), forCellReuseIdentifier: "ApprovedPrescriptionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let nav = self.navigationController {
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.view.backgroundColor = .clear
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            
            if !nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
        getAllPrescriptionsFromUserDefault()
        //getAllPrescriptionsFromService()
    }
    //Get all prescriptions in NSUSERDEFAULTS
    func getAllPrescriptionsFromUserDefault() {
        //Get all presciptions from prescription manager
        PrescriptionManager.shared.getAllPrescription { (prescription, error) in
            //if error
            if let err = error {
                print(err)
                return
            } else {
                if let preObject = prescription {
                    self.prescriptionsCreated = preObject
                    self.tblPrescriptions.reloadData()
                }
            }
            
           self.tblPrescriptions.reloadData()
            
        }
    }
    
    func getAllPrescriptionsFromService() {
        
        //Get all prescriptions of user from Service
        PrescriptionService.shared.getPrescriptions { (prescription, error) in
            
            DispatchQueue.main.async {
                self.tblPrescriptions.reloadData()
                self.btnCreatedPre.isEnabled = true
                self.btnOrderedPre.isEnabled = true
                self.btnRejectedPre.isEnabled = true
                self.btnRequestedPre.isEnabled = true
            }
            
            if let error = error {
                print("GET ALL PRESCRIPTION FROM SERVICE NOT COMPLETE WITH ERROR: \(error)")
                return
            }
            
            guard let prescription = prescription else {
                print("GET ALL PRESCRIPTION FROM SERVICE NOT COMPLETE WITH ERROR")
                return
            }

            switch prescription.status {
            //pending
            case .pending :
                self.prescriptionsPending.append(prescription)
            //accepted
            case .approved :
                self.prescriptionsOrder.append(prescription)
            //rejected
            case .rejected :
                self.prescriptionsRejected.append(prescription)
            default:
                break
            }
        }
    }
 
    // - MARK: ACTION
    @IBAction func btnAddPrescriptionClicked(_ sender: Any) {
        if let nav = self.navigationController {
            if let sb = storyboard?.instantiateViewController(withIdentifier: "AddPrescriptionVC") as? AddPrescriptionVC {
                nav.pushViewController(sb, animated: true)
            }
        }
    }
    
    
    @IBAction func btnCreatedPreClicked(_ sender: Any) {
        btnCreatedPre.isEnabled = false
        selectionType = .creating
        prescriptionsCreated = []
        tblPrescriptions.reloadData()
        getAllPrescriptionsFromUserDefault()
    }
    
    @IBAction func btnRequestedPreClicked(_ sender: Any) {
        btnRequestedPre.isEnabled = false
        selectionType = .pending
        prescriptionsPending = []
        tblPrescriptions.reloadData()
        getAllPrescriptionsFromService()
    }
    
    @IBAction func btnRejectedPreClicked(_ sender: Any) {
        btnRejectedPre.isEnabled = false
        selectionType = .rejected
        prescriptionsRejected = []
        tblPrescriptions.reloadData()
        getAllPrescriptionsFromService()
    }
    
    @IBAction func btnOrderedPreClicked(_ sender: Any) {
        btnOrderedPre.isEnabled = false
        selectionType = .approved
        prescriptionsOrder = []
        tblPrescriptions.reloadData()
        getAllPrescriptionsFromService()
    }
}

extension PrescriptionVC: UITableViewDataSource, UITableViewDelegate, ManagerPrescriptionCell {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectionType {
        case .creating:
            return prescriptionsCreated.count
        case .pending:
            return prescriptionsPending.count
        case .rejected:
            return prescriptionsRejected.count
        case .approved:
            return prescriptionsOrder.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectionType {
        case .creating:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitPrescriptionCell", for: indexPath) as? SubmitPrescriptionCell else {
                return UITableViewCell()
            }
            
            cell.prescription = prescriptionsCreated[indexPath.row]
            cell.lblName.text = prescriptionsCreated[indexPath.row].name
            cell.lblTotalDrugs.text = String(prescriptionsCreated[indexPath.row].drugs.count)
            //cell.lblTotalPrice.text = String(prescriptionsCreated[indexPath.row].totalPrice) + " VND"
            cell.lblStatus.text = prescriptionsCreated[indexPath.row].status.rawValue
            cell.lblDateCreated.text = prescriptionsCreated[indexPath.row].dateCreate
            cell.delegate = self
            return cell
            
        case .pending:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PendingPrescriptionCell", for: indexPath) as? PendingPrescriptionCell else {
                return UITableViewCell()
            }
            cell.prescription = prescriptionsPending[indexPath.row]
            cell.lblName.text = prescriptionsPending[indexPath.row].name
            cell.lblStatus.text = prescriptionsPending[indexPath.row].status.rawValue
            cell.lblDate.text = prescriptionsPending[indexPath.row].dateCreate
            return cell
            
        case .approved:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovedPrescriptionCell", for: indexPath) as? ApprovedPrescriptionCell else {
                return UITableViewCell()
            }
            cell.prescription = prescriptionsOrder[indexPath.row]
            cell.lblName.text = prescriptionsOrder[indexPath.row].name
            //cell.lblTotalPrice.text = String(prescriptionsOrder[indexPath.row].totalPrice) + " VND"
            cell.lblStatus.text = prescriptionsOrder[indexPath.row].status.rawValue
            cell.lblDateCreated.text = prescriptionsOrder[indexPath.row].dateCreate
            return cell
        case .rejected:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RejectedPrescriptionCell", for: indexPath) as? PendingPrescriptionCell else {
                return UITableViewCell()
            }
            cell.prescription = prescriptionsRejected[indexPath.row]
            cell.lblName.text = prescriptionsRejected[indexPath.row].name
            cell.lblStatus.text = prescriptionsRejected[indexPath.row].status.rawValue
            cell.lblDate.text = prescriptionsRejected[indexPath.row].dateCreate
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectionType {
        case .approved:
            return 100
        case .pending:
           return 100
        case .rejected:
            return 100
        case .creating:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectionType {
        case .approved:
            
            if let sb = storyboard?.instantiateViewController(withIdentifier: "OrderPrescriptionVC") as? OrderPrescriptionVC {
                
                sb.prescription = prescriptionsOrder[indexPath.row]
                self.navigationController?.pushViewController(sb, animated: true)
            }
        case .pending:
            print(prescriptionsPending[indexPath.row].id)
        case .rejected:
            print(prescriptionsRejected[indexPath.row].id)
        case .creating:
            print(prescriptionsCreated[indexPath.row].id)
        }
    }
    
    func deletePre(with id: Int) {
        //print(id)
        if let index = prescriptionsCreated.index(where: { (pre) -> Bool in
            return pre.id == id
        }) {
            ///delete
            prescriptionsCreated.remove(at: index)
            //self.tblPrescriptions.reloadData()
            self.tblPrescriptions.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .fade)
        }
    }
    
    func submitPre(with prescription: PrescriptionObject) {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(toVC: self)
        PrescriptionService.shared.submitPrescription(with: prescription) { (error) in
            activityIndicatorView.stopLoadingDialog()
            if let error = error {
                print("SUBMIT PRESCRIPTION WITH ERROR: \(error)")
                return
            }
            print("Submit Okay")
            //del pre in array
            PrescriptionManager.shared.deletePresciption(withId: prescription.id, completionHandler: { (error) in
                if let error = error {
                    print("DELETE PRESCRIPTION INCOMPLETED: \(error)")
                }
                self.deletePre(with: prescription.id)
            })
            
            let alert = UIAlertController(title: "Gửi yêu cầu thành công!", message: "Gửi đơn thuốc thành công, đang đợi xét duyệt.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            
            self.showStoryBoard(vc: alert)
            
        }
    }
}

protocol ManagerPrescriptionCell {
    func deletePre(with id: Int) -> Void
    func submitPre(with prescription: PrescriptionObject) -> Void
}
