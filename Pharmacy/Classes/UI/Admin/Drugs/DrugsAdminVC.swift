//
//  DrugsVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugsAdminVC: UIViewController {

    @IBOutlet weak var tblDrugs: UITableView!
    var drugs: [DrugObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDrugs.register(UINib(nibName: "DrugAdminCell", bundle: nil), forCellReuseIdentifier: "DrugAdminCell")
        tblDrugs.dataSource = self
        tblDrugs.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDrugs()
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
    }
    
    // - MARK: FUNCTIONS
    func getDrugs() {
        DrugsService.shared.getDrugs { (drugs, error) in
            
            if let error = error {
                print("ERROR " + error)
                return
            }
            if let data = drugs as? [DrugObject] {
                
                self.drugs = data
                DispatchQueue.main.async {
                    self.tblDrugs.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnAddDrugClicked(_ sender: Any) {
        if let nav = self.navigationController {
            if let sb = storyboard?.instantiateViewController(withIdentifier: "AddDrugAdminVC") as? AddDrugAdminVC {
                nav.pushViewController(sb, animated: true)
            }
        }
    }
}

extension DrugsAdminVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrugAdminCell", for: indexPath) as? DrugAdminCell else {
            return UITableViewCell()
        }
        
        cell.drug = drugs[indexPath.row]
        cell.lblPrice.text = String(drugs[indexPath.row].price)
        cell.lblName.text = drugs[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
