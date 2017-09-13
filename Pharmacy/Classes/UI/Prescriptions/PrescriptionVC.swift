//
//  PrescriptionVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/13/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PrescriptionVC: UIViewController {

    @IBOutlet weak var tblPrescriptions: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPrescriptions.dataSource = self
        tblPrescriptions.delegate = self
        
        tblPrescriptions.register(UINib(nibName: "PrescriptionCell", bundle: nil), forCellReuseIdentifier: "PrescriptionCell")
    }

    
    @IBAction func btnAddPrescriptionClicked(_ sender: Any) {
    }

}

extension PrescriptionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell", for: indexPath) as? PrescriptionCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
