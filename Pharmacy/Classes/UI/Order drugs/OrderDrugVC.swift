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
        
        tblDrugs.register(UINib(nibName: "DrugOfNewPresciptionCell", bundle: nil), forCellReuseIdentifier: "DrugOfNewPresciptionCell")
        tblDrugs.delegate = self
        tblDrugs.dataSource = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "All available drugs "
        //getDrugs()
        
    }
    
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
                return
            } else {
                print("GET DRUGS ERROR")
                return
            }
            
           
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDrugs()
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
        guard let cell = tblDrugs.dequeueReusableCell(withIdentifier: "DrugOfNewPresciptionCell", for: indexPath) as? DrugOfNewPresciptionCell else {
            return UITableViewCell()
        }
        
        cell.txtName.text = drugs[indexPath.row].name
        cell.txtPrice.text = String(drugs[indexPath.row].price)

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("ID: \(drugs[indexPath.row].id)"  )
        
        
        if let sb = UIStoryboard(name: "DrugDetailDialog", bundle: nil).instantiateInitialViewController() as? DrugDialogVC {
            self.addChildViewController(sb)
            self.view.addSubview(sb.view)
            sb.view.frame = view.bounds
            sb.didMove(toParentViewController: self)
            
            sb.lblName.text = drugs[indexPath.row].name
            sb.lblDonGia.text = String(drugs[indexPath.row].price)
            sb.lblHDSD.text = drugs[indexPath.row].instructions
            sb.lblCongThuc.text = drugs[indexPath.row].formula
            sb.lblCachSuDung.text = drugs[indexPath.row].howToUse
            sb.lblTacDungPhu.text = drugs[indexPath.row].sideEffect
            sb.lblChongChiDinh.text = drugs[indexPath.row].contraindication
            sb.idDrug = drugs[indexPath.row].id
            
        }
        
        
        
        
    }
}
