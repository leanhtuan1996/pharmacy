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
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var tblDetailsOrder: UITableView!
    
    var id: Int?
    var date: String?
    var totalPrice: Int?
    var orderHistory: OrderObject?
    var drugOfOrder: [DrugObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDetailsOrder.delegate = self
        tblDetailsOrder.dataSource = self
        tblDetailsOrder.register(UINib(nibName: "DetailOrderHistoryCells", bundle: nil), forCellReuseIdentifier: "DetailOrderHistoryCells")        
        getDetailOrderHistory(withId: id)
        
        if let date = date, let id = id, let totalPrice = totalPrice {
            lblId.text = String(id)
            lblDate.text = date
            lblTotalPrice.text = String(totalPrice)
        }
    }
    
    func getDetailOrderHistory(withId id: Int?) {
        guard let idDrug = id else {
            print("ID CAN NOT EMPTY")
            return
        }
        
        OrderService.shared.getDetailOrder(id: idDrug) { (isSuccess, orderHistory, error) in
            if isSuccess {
                if let orderObject = orderHistory {
                    self.orderHistory = orderObject
                    self.drugOfOrder = orderObject.drugs
                    DispatchQueue.main.async {
                        self.tblDetailsOrder.reloadData()
                    }
                } else {
                    print("GET DETAIL ORDER HISTORY ERROR")
                }
            } else {
                if let err = error {
                    print(err)
                } else {
                    print("GET DETAIL ORDER HISTORY ERROR")
                }
            }
        }
    }
}

extension DetailsOrderHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugOfOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrderHistoryCells", for: indexPath) as? DetailOrderHistoryCells else {
            return UITableViewCell()
        }
        
        cell.lblId.text = String(drugOfOrder[indexPath.row].id)
        cell.lblName.text = drugOfOrder[indexPath.row].name
        cell.lblPrice.text = String(drugOfOrder[indexPath.row].price)
        cell.lblTotalQuantity.text = String(drugOfOrder[indexPath.row].quantity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
