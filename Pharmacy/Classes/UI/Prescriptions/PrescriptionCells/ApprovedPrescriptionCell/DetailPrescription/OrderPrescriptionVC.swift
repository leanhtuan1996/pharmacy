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
    var drugsSelected: [DrugObject] = []
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
        
        if let pre = prescription {
            //Load detail prescription
            getDetailPrescription(with: pre.id)
        }
    }
    
    func getDetailPrescription(with id: Int) {
        PrescriptionService.shared.getDetailPrescription(with: id) { (pre, error) in
            if let error = error {
                print("GET DETAIL PRESCRIPTION WITH ERROR: \(error)")
                return
            }
            
            if let pre = pre {
                self.prescription = pre
                self.tblDrugs.reloadData()
            }
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOrderClicked(_ sender: Any) {
        
        if let prescription = prescription, drugsSelected.count > 0 {
            var drugs:[[String: Any]] = []
            
            for drug in drugsSelected {
                let temp: [String: Any] = [
                    "id" : drug.id,
                    "quantity" : drug.quantity
                ]
                drugs.append(temp)
            }
            
            let parameter: [String: Any] = [
                "drugs" : drugs,
                "date" : Date.getDate(),
                "prescriptionID": prescription.id
            ]
            
            OrderService.shared.newOrder(parameter: parameter, completionHandler: { (error) in
                
                let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                if let error = error {
                    alert.title = "Order incompleted"
                    alert.message = "Order incompleted with error: \(error)"
                    alert.addAction(UIAlertAction.init(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
                } else {
                    alert.title = "Order completed"
                    alert.message = "Your precription had been completed"
                    alert.addAction(UIAlertAction.init(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                }
                self.showStoryBoard(vc: alert)
            })
        } else {
            print("ERROR")
        }
    }
}

extension OrderPrescriptionVC: UITableViewDelegate, UITableViewDataSource, ChooseDrugOrder {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescription?.drugs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrugsOfOrderPrescriptionCell", for: indexPath) as? DrugsOfOrderPrescriptionCell else {
            return UITableViewCell()
        }
        
        cell.drug = prescription?.drugs[indexPath.row] ?? DrugObject()
        cell.lblName.text = prescription?.drugs[indexPath.row].name ?? ""
        cell.lblPrice.text = String(prescription?.drugs[indexPath.row].price ?? 0)
        cell.delegate = self
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func choose(with drug: DrugObject) {
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
        var totalPrice = 0
        for temp in drugsSelected {
            totalPrice = totalPrice + (temp.quantity * temp.price)
        }
        lblTotalPrice.text = String(totalPrice)
        lblTotalDrug.text = String(drugsSelected.count)
    }
}
protocol ChooseDrugOrder {
    func choose(with drug: DrugObject) -> Void
}
