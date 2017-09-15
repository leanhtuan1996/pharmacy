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
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    //show all drugs to add
    var drugs: [DrugObject] = []
    
    var drugsSelected: [DrugObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListDrugs.delegate = self
        tblListDrugs.dataSource = self
        tblListDrugs.register(UINib(nibName: "DrugCell", bundle: nil), forCellReuseIdentifier: "DrugCell")
        
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
        DrugsService.shared.getDrugs { (isSuccess, drugs, error) in
            if isSuccess {
                if let data = drugs as? [DrugObject] {
                   
//                    if let index = data.index(where: { (drug) -> Bool in
//                        return drug.id == 1
//                    }) {
//                        print(index)
//                        data.remove(at: index)
//                    }
//                    
//                    print(data.count)
                    
                    self.drugs = data
                    DispatchQueue.main.async {
                        self.tblListDrugs.reloadData()
                    }
                    return
                }
                
            } else {
                if let error = error {
                    print("ERROR " + error)
                    return
                }
            }
            
            
        }
    }
    
    func addPrescription(with prescription: PrescriptionObject) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        txtNameOfPre.isEnabled = false
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.white
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.bounds
        activityIndicatorView.center = self.view.center
        activityIndicatorView.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        activityIndicatorView.startAnimating()
        PrescriptionManager.shared.addPrescription(with: prescription) { (error) in
            self.txtNameOfPre.isEnabled = true
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            activityIndicatorView.stopAnimating()
            if let err = error {
                print(err)
                return
            }
            print("OKAY")
            let alert = UIAlertController(title: "Add prescription", message: "Add Prescription Successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back to main", style: .default, handler: { (btn) in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.showStoryBoard(vc: alert)
        }
    }
    
    // - MARK: FUNC IN PROTOCOL
    func addDrug(with drug: DrugObject) {
        //print(drug.quantity)
       //nếu số lượng = 0 thì xoá trong array
        if drug.quantity == 0 {
            if let index = drugsSelected.index(where: { (drugWhere) -> Bool in
                return drugWhere.id == drug.id
            }) {
                //xoá
                drugsSelected.remove(at: index)
            }
        } else {
            //nếu sl # 0
            //- 1: Check drug đó có trong arrray hay không
            //- Có: sửa số lượng
            //- Không: thêm drug vào array
            if let index = drugsSelected.index(where: { (drugWhere) -> Bool in
                return drugWhere.id == drug.id
            }) {
                //sửa số lượng
                drugsSelected[index].quantity = drug.quantity
                
            } else {
                drugsSelected.append(drug)
            }
        }
        
        print(drugsSelected.count)
        
        //Cập nhật lại số lượng & giá
        lblTotalDrugs.text = String(drugsSelected.count)
        
        var totalPrice = 0
        for temp in drugsSelected {
            totalPrice = totalPrice + (temp.quantity * temp.price)
        }
        
        lblTotalPrice.text = String(totalPrice)
    }
    
    // - MARK: ACTION
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDoneClicked(_ sender: Any) {
        guard let name = txtNameOfPre.text, let totalDrugs = lblTotalDrugs.text, let totalDrugsInt = Int(totalDrugs) , let totalPrice = lblTotalPrice.text, let totalPriceInt = Int(totalPrice) else {
            let alert = UIAlertController(title: "Fail", message: "Fields are required", preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default, handler: nil))
            self.showStoryBoard(vc: alert)
            return
        }
        
        if name.isEmpty {
            let alert = UIAlertController(title: "Fail", message: "Fields are required", preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default, handler: nil))
            self.showStoryBoard(vc: alert)
            return
        }
       
        if totalDrugsInt == 0 || totalPriceInt == 0 {
            let alert = UIAlertController(title: "Fail", message: "Please choose drugs", preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default, handler: nil))
            self.showStoryBoard(vc: alert)
            return
        }
        
        //let add to nsuserdefault
        let pre = PrescriptionObject()
        pre.name = name
        pre.dateCreate = Utilities.getDate()
        pre.totalPrice = totalPriceInt
        pre.drugs = drugsSelected
        addPrescription(with: pre)
    }

}

extension AddPrescriptionVC: UITableViewDelegate, UITableViewDataSource, ActionWhenChooseDrug {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrugCell", for: indexPath) as? DrugCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.txtName.text = drugs[indexPath.row].name
        cell.txtPrice.text = String(drugs[indexPath.row].price)
        cell.drug = drugs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

protocol ActionWhenChooseDrug {
    func addDrug(with drug: DrugObject) -> Void
}
