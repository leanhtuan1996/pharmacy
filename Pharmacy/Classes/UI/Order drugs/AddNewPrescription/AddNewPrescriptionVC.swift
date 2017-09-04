//
//  AddNewPrescription.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class AddNewPrescriptionVC: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var tblDrugs: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var drugs: [DrugObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblDrugs.register(UINib(nibName: "DrugCell", bundle: nil), forCellReuseIdentifier: "DrugCell")
        tblDrugs.delegate = self
        tblDrugs.dataSource = self
        
        
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
                    print(error)
                    return
                }
            }
        }
        
    }
    
    // - MARK: ACTION
    @IBAction func btnAddPrescriptionClicked(_ sender: Any) {
    }
    

}

extension AddNewPrescriptionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblDrugs.dequeueReusableCell(withIdentifier: "DrugCell", for: indexPath) as? DrugCell else {
            return UITableViewCell()
        }        
        
        cell.txtName.text = drugs[indexPath.row].name
        cell.txtPrice.text = String(drugs[indexPath.row].price)
        cell.txtSTT.text = String(indexPath.row)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
