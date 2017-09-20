//
//  AddPrescriptionVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/14/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class AddPrescriptionVC: UIViewController {
    @IBOutlet weak var tblListDrugs: UITableView!
    @IBOutlet weak var txtNameOfPre: UITextField!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblTotalDrugs: UILabel!
    
    //show all drugs to add
    var drugs: [DrugObject] = []
    var drugsSelected: [DrugObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListDrugs.delegate = self
        tblListDrugs.dataSource = self
        tblListDrugs.register(UINib(nibName: "DrugOfNewPresciptionCell", bundle: nil), forCellReuseIdentifier: "DrugOfNewPresciptionCell")
        
        getDrugs()
        
        if let nav = self.navigationController {
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.view.backgroundColor = .clear
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
            
            if nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(false, animated: true)
            } else {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    // - MARK: FUNCTIONS
    func getDrugs() {
        DrugsService.shared.getDrugs { (drugs, error) in
            
            if let error = error {
                print("ERROR " + error)
                return
            }
            if let data = drugs {
                
                self.drugs = data
                DispatchQueue.main.async {
                    self.tblListDrugs.reloadData()
                }
                return
            }
        }
    }
    
    func addPrescription(with prescription: PrescriptionObject) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(self)
        
        PrescriptionManager.shared.addPrescription(with: prescription)
        let alert = UIAlertController(title: "Add prescription", message: "Add Prescription Successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back to main", style: .default, handler: { (btn) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.showStoryBoard(alert)
    }
    
    // - MARK: FUNC IN PROTOCOL
    func addDrug(with drug: DrugObject) {
        //print(drug.id)
        drugsSelected.append(drug)
        lblTotalDrugs.text = String(drugsSelected.count)
    }
    
    func delDrug(with drug: DrugObject) {
        
        if let index = drugsSelected.index(where: { (d) -> Bool in
            return d.id == drug.id
        }) {
            //print(drug.id)
            drugsSelected.remove(at: index)
            lblTotalDrugs.text = String(drugsSelected.count)
        }
    }
    
    // - MARK: ACTION
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDoneClicked(_ sender: Any) {
        guard let name = txtNameOfPre.text, let totalDrugs = lblTotalDrugs.text, let totalDrugsInt = Int(totalDrugs) else {
            let alert = UIAlertController(title: "Add prescription incomplete", message: "Fields are required", preferredStyle: .alert)
            alert.addAction(.init(title: "Re try", style: .default, handler: nil))
            self.showStoryBoard(alert)
            return
        }
        
        if name.isEmpty {
            let alert = UIAlertController(title: "Add prescription incomplete", message: "Fields are required", preferredStyle: .alert)
            alert.addAction(.init(title: "Re try", style: .default, handler: nil))
            self.showStoryBoard(alert)
            return
        }
        
        if totalDrugsInt == 0 {
            let alert = UIAlertController(title: "Fail", message: "Please choose drugs", preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default, handler: nil))
            self.showStoryBoard(alert)
            return
        }
        
        //let add to nsuserdefault
        let pre = PrescriptionObject()
        pre.name = name
        pre.dateCreate = Date.getDate()
        pre.drugs = drugsSelected
        addPrescription(with: pre)
    }
    
}

extension AddPrescriptionVC: UITableViewDelegate, UITableViewDataSource, ActionWhenChooseDrug {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrugOfNewPresciptionCell", for: indexPath) as? DrugOfNewPresciptionCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.txtName.text = drugs[indexPath.row].name
        cell.drug = drugs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

protocol ActionWhenChooseDrug {
    func addDrug(with drug: DrugObject) -> Void
    func delDrug(with drug: DrugObject) -> Void
}
