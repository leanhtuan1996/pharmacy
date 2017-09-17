//
//  CheckOutVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class CheckOutVC: UIViewController {
    @IBOutlet weak var tblDrugsToOrder: UITableView!
    
    var drugsToOrder: [DrugObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tblDrugsToOrder.delegate = self
        tblDrugsToOrder.dataSource = self
        tblDrugsToOrder.register(UINib(nibName: "OrderDrugsCell", bundle: nil), forCellReuseIdentifier: "OrderDrugsCell")
        navigationItem.title = "My Cart"
        getAllOrdersFromCart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOrderClicked(_ sender: Any) {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.white
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.bounds
        activityIndicatorView.center = self.view.center
        activityIndicatorView.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        activityIndicatorView.startAnimating()

        OrderManager.shared.checkOut(drugToOrders: drugsToOrder) { (error) in
            activityIndicatorView.stopAnimating()
            
            if let error = error {
                print("CHECK OUT ERROR: \(error)")
                return
            }
            
            let alert = UIAlertController(title: "Notify", message: "ORDER SUCCESSFULLY", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CONTINUE TO ORDER", style: .default, handler: { (btn) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.showStoryBoard(vc: alert)
        }
        
    }
    
    func getAllOrdersFromCart() {
        OrderManager.shared.getAllOrdersFromCart { (drug, error) in
           
            if let error = error {
                print(error)
                return
            }
            
            if let drug = drug {
                //print(drug.quantity)
                self.drugsToOrder.append(drug)
                DispatchQueue.main.async {
                    self.tblDrugsToOrder.reloadData()
                }
            }
        }
    }

}

extension CheckOutVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugsToOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDrugsCell", for: indexPath) as? OrderDrugsCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = drugsToOrder[indexPath.row].name
        cell.lblPrice.text = String(drugsToOrder[indexPath.row].price)
        cell.lblQuantity.text = String(drugsToOrder[indexPath.row].quantity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
