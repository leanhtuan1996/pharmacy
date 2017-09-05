//
//  OrderDrug.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class OrderDrugVC: UIViewController {
    
    @IBOutlet weak var tblDrugs: UITableView!
    
    var drugs: [DrugObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblDrugs.register(UINib(nibName: "DrugCell", bundle: nil), forCellReuseIdentifier: "DrugCell")
        tblDrugs.delegate = self
        tblDrugs.dataSource = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        DrugsService.shared.getDrugs { (isSuccess, drugs, error) in
            if isSuccess {
                if let data = drugs as? [DrugObject]{
                    self.drugs = data
                    DispatchQueue.main.async {
                        self.tblDrugs.reloadData()
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
    
    // - MARK: ACTION
    @IBAction func btnOrderDrugsClicked(_ sender: Any) {
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OrderDrugVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblDrugs.dequeueReusableCell(withIdentifier: "DrugCell", for: indexPath) as? DrugCell else {
            return UITableViewCell()
        }
        
        cell.txtName.text = drugs[indexPath.row].name
        cell.txtPrice.text = String(drugs[indexPath.row].price)
        cell.lblFormula.text = drugs[indexPath.row].formula
        cell.lblHowToUse.text = drugs[indexPath.row].howToUse
        cell.lblInstructions.text = drugs[indexPath.row].instructions
        cell.lblSideEffect.text = drugs[indexPath.row].sideEffect
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
