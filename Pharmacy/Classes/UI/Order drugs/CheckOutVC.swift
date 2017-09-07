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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOrderClicked(_ sender: Any) {
    }
    

}

extension CheckOutVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDrugsCell", for: indexPath) as? OrderDrugsCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
}
