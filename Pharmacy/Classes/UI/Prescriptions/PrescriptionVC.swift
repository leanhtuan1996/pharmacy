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
            DispatchQueue.main.async {
                self.tblPrescriptions.reloadData()
            }
        }
    }
    
    func getAllPrescriptionsFromService() {
        
        //Get all prescriptions of user from Service
        PrescriptionService.shared.getPrescriptions { (prescriptionArray, error) in
            if let error = error {
                print("GET ALL PRESCRIPTION FROM SERVICE NOT COMPLETE WITH ERROR: \(error)")
                return
            }
            
            guard let prescriptionArray = prescriptionArray else {
                print("GET ALL PRESCRIPTION FROM SERVICE NOT COMPLETE WITH ERROR")
                return
            }
            
            for pre in prescriptionArray {
                switch pre.status {
                //pending
                case .pending :
                    self.prescriptionsPending.append(pre)
                //accepted
                case .approved :
                    self.prescriptionsOrder.append(pre)
                //rejected
                case .rejected :
                    self.prescriptionsRejected.append(pre)
                default:
                    break
                }
            }
            self.tblPrescriptions.reloadData()
            
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
        selectionType = .creating
        getAllPrescriptionsFromUserDefault()
    }
    
    @IBAction func btnRequestedPreClicked(_ sender: Any) {
        selectionType = .pending
        prescriptionsPending = []
        getAllPrescriptionsFromService()
    }
    
    @IBAction func btnRejectedPreClicked(_ sender: Any) {
        selectionType = .rejected
        prescriptionsRejected = []
        getAllPrescriptionsFromService()
    }
    
    @IBAction func btnOrderedPreClicked(_ sender: Any) {
        selectionType = .approved
        prescriptionsOrder = []
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
        print(selectionType.rawValue)
        switch selectionType {
        case .creating:
           
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitPrescriptionCell", for: indexPath) as? SubmitPrescriptionCell else {
                return UITableViewCell()
            }
            
            cell.prescription = prescriptionsCreated[indexPath.row]
            cell.lblName.text = prescriptionsCreated[indexPath.row].name
            cell.lblTotalDrugs.text = String(prescriptionsCreated[indexPath.row].drugs.count)
            cell.lblTotalPrice.text = String(prescriptionsCreated[indexPath.row].totalPrice) + " VND"
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
            cell.lblTotalDrug.text = String(prescriptionsPending[indexPath.row].drugs.count)
            cell.lblTotalPrice.text = String(prescriptionsPending[indexPath.row].totalPrice) + " VND"
            cell.lblStatus.text = prescriptionsPending[indexPath.row].status.rawValue
            cell.lblDate.text = prescriptionsPending[indexPath.row].dateCreate
            return cell
            
        case .approved:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PendingPrescriptionCell", for: indexPath) as? PendingPrescriptionCell else {
                return UITableViewCell()
            }
            
            return cell
        case .rejected:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PendingPrescriptionCell", for: indexPath) as? PendingPrescriptionCell else {
                return UITableViewCell()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(prescriptionsCreated[indexPath.row].name)
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
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.white
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.bounds
        activityIndicatorView.center = self.view.center
        activityIndicatorView.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        activityIndicatorView.startAnimating()
        PrescriptionService.shared.submitPrescription(with: prescription) { (error) in
            activityIndicatorView.stopAnimating()
            if let error = error {
                print("SUBMIT PRESCRIPTION WITH ERROR: \(error)")
                return
            }
            print("Submit Okay")
        }
    }
}

protocol ManagerPrescriptionCell {
    func deletePre(with id: Int) -> Void
    func submitPre(with prescription: PrescriptionObject) -> Void
}
