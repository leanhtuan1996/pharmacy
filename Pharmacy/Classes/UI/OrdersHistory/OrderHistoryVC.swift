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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tblOrderHistory.dataSource = self
        tblOrderHistory.delegate = self
        tblOrderHistory.register(UINib(nibName: "OrderHistoryCells", bundle: nil) , forCellReuseIdentifier: "OrderHistoryCells")
        
        getOrdersHistory()
    }
    
    func getOrdersHistory() {
        OrderService.shared.getOrdersHistory { (isSuccess, orderObject, error) in
             if isSuccess {
                if let orderArray = orderObject as? [OrderObject] {
                    self.ordersHistory = orderArray
                    print(orderArray.count)
                    DispatchQueue.main.async {
                        self.tblOrderHistory.reloadData()
                    }
                } else {
                    print("GET ORDERS HISTORY NOT SUCCESSFULLY")
                }
            } else {
                if let error = error {
                    print(error)
                } else {
                    print("GET ORDERS HISTORY NOT SUCCESSFULLY")
                }
            }
        }
    }
    
//    func getDetailOrder(id: Int) {
//        OrderManager.shared.getDetailOrderHistory(id: id) { (isSuccess, orderObject, error) in
//            if isSuccess {
//                if let _ = orderObject as? OrderObject {
//                    
//                } else {
//                    print("GET ORDERS HISTORY NOT SUCCESSFULLY")
//                }
//            } else {
//                if let err = error {
//                    print(err)
//                } else {
//                    print("GET ORDERS HISTORY NOT SUCCESSFULLY")
//                }
//            }
//        }
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        cell.lblPrice.text = String(ordersHistory[indexPath.row].totalPrice)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
