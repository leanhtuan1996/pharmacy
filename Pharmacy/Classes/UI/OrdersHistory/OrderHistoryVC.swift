//
//  OrderHistoryVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class OrderHistoryVC: UIViewController {
    @IBOutlet weak var tblOrderHistory: UITableView!
    
    var ordersHistory: [OrderObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrderHistory.dataSource = self
        tblOrderHistory.delegate = self
        tblOrderHistory.register(UINib(nibName: "OrderHistoryCells", bundle: nil) , forCellReuseIdentifier: "OrderHistoryCells")
        getOrdersHistory()
    }
    
    func getOrdersHistory() {
        OrderService.shared.getOrdersHistory { (orderObject, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let orderArray = orderObject {
                self.ordersHistory = orderArray
                //print(orderArray.count)
                DispatchQueue.main.async {
                    self.tblOrderHistory.reloadData()
                }
            } else {
                print("GET ORDERS HISTORY NOT SUCCESSFULLY")
            }
        }
    }

}

extension OrderHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCells", for: indexPath) as? OrderHistoryCells else {
            return UITableViewCell()
        }
        cell.lblId.text = String(ordersHistory[indexPath.row].id)
        cell.lblDate.text = ordersHistory[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
//        self.performSegue(withIdentifier: "DetailsOrderHistoryVC", sender: tableView.cellForRow(at: indexPath))
    }
    
}
