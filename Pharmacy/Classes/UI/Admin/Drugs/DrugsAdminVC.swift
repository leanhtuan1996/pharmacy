//
//  DrugsVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugsAdminVC: UIViewController {

    @IBOutlet weak var uiSearchBar: UISearchBar!
    @IBOutlet weak var tblDrugs: UITableView!
    var drugs: [DrugObject] = []
    var drugsFilter: [DrugObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDrugs.register(UINib(nibName: "DrugAdminCell", bundle: nil), forCellReuseIdentifier: "DrugAdminCell")
        tblDrugs.dataSource = self
        tblDrugs.delegate = self
        tblDrugs.estimatedRowHeight = 80
        uiSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        getDrugs()
        if let nav = self.navigationController {
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.view.backgroundColor = .clear
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
            
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
            if let data = drugs {
                
                self.drugs = data
                self.drugsFilter = data
                DispatchQueue.main.async {
                    self.tblDrugs.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnAddDrugClicked(_ sender: Any) {
        
        if let sb = storyboard?.instantiateViewController(withIdentifier: "AddEditDrugAdminVC") as? AddEditDrugAdminVC {
            self.addChildViewController(sb)
            self.view.addSubview(sb.view)
            sb.didMove(toParentViewController: self)
            sb.view.frame = self.view.frame
            sb.delegate = self
            sb.view.tag = 100
            sb.titleAction = "New Drug"
        }
        
    }
    
}

extension DrugsAdminVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate , DrugDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugsFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrugAdminCell", for: indexPath) as? DrugAdminCell else {
            return UITableViewCell()
        }
        
        cell.drug = drugsFilter[indexPath.row]
        cell.lblName.text = drugsFilter[indexPath.row].name
        cell.delegate = self
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sb = storyboard?.instantiateViewController(withIdentifier: "AddEditDrugAdminVC") as? AddEditDrugAdminVC else {
            self.showAlert("View Controller Not Found", title: "error", buttons: nil)
            return
        }
        sb.currentDrug = drugs[indexPath.row]
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        drugsFilter = searchText.isEmpty ? drugs : drugs.filter({ (drug) -> Bool in
            return drug.name?.range(of: searchText.lowercased()) != nil
        })
        tblDrugs.reloadData()
    }
    
    func delete(with id: Int) {
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(self)
        DrugsService.shared.deleteDrug(with: id) { (error) in
            activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert("Delete drug failed with error: \(error)", title: "Error", buttons: nil)
                return
            }
            
            if let index = self.drugsFilter.index(where: { (d) -> Bool in
                return d.id == id
            }) {
                self.drugsFilter.remove(at: index)
                self.tblDrugs.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: UITableViewRowAnimation.fade)
                self.getDrugs()
            } else {
                self.getDrugs()
            }
        }
    }
    
    func add(with drug: DrugObject) {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(self)
        DrugsService.shared.addDrug(drug) { (error) in
            activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Add new drug incompleted", buttons: nil)
                return
            }
            let alertAction = UIAlertAction(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                self.getDrugs()
                if let viewWithTag = self.view.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
            })
            
            self.showAlert("Add new drug successfully", title: "Success", buttons: [alertAction])
        }
        
    }
    
}

protocol DrugDelegate {
    func delete(with id: Int) -> Void
    func add(with drug: DrugObject) -> Void
}
