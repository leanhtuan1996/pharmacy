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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        getOrdersHistory()
    }
    
    func getOrdersHistory() {
        OrderService.shared.getOrdersHistory { (orderObject, error) in
           
            if let error = error {
                print(error)
                return
            }
            self.ordersHistory = []
            if let orderArray = orderObject {
                self.ordersHistory = orderArray
            } else {
                print("GET ORDERS HISTORY NOT SUCCESSFULLY")
            }
            
            self.tblOrderHistory.reloadData()
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
        cell.lblId.text = String(ordersHistory[indexPath.row].id ?? 0)
        cell.lblDate.text = ordersHistory[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "DetailsOrderHistoryVC") as? DetailsOrderHistoryVC {
            sb.orderHistory = ordersHistory[indexPath.row]
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
}
