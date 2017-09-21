//
//  DetailsOrderHistoryVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DetailsOrderHistoryVC: UIViewController {

    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTotalDrugs: UILabel!
    @IBOutlet weak var tblDetailsOrder: UITableView!
    
    var orderHistory: OrderObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDetailsOrder.delegate = self
        tblDetailsOrder.dataSource = self
        tblDetailsOrder.register(UINib(nibName: "DetailOrderHistoryCells", bundle: nil), forCellReuseIdentifier: "DetailOrderHistoryCells")
        tblDetailsOrder.estimatedRowHeight = 120
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let orderDetail = orderHistory {
            lblId.text = String(orderDetail.id ?? 0)
            lblDate.text = orderDetail.date
            lblTotalDrugs.text = String(orderDetail.drugs?.count ?? 0)
            getDetailOrderHistory(withId: orderDetail.id ?? 0)
        }
        
    }
    
    func getDetailOrderHistory(withId id: Int) {
        
        OrderService.shared.getDetailOrder(id) { (orderHistory, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let orderObject = orderHistory {
                self.orderHistory = orderObject
                self.lblTotalDrugs.text = String(orderObject.drugs?.count ?? 0)
                self.tblDetailsOrder.reloadData()
            } else {
                print("GET DETAIL ORDER HISTORY ERROR")
            }
        }
    }
}

extension DetailsOrderHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistory?.drugs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrderHistoryCells", for: indexPath) as? DetailOrderHistoryCells else {
            return UITableViewCell()
        }
        
        if let drugs = orderHistory?.drugs {
            cell.lblName.text = drugs[indexPath.row].name
            cell.lblTotalQuantity.text = String(drugs[indexPath.row].quantity ?? 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
