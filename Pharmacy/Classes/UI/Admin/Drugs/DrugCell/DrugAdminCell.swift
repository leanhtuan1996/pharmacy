//
//  DrugAdminCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugAdminCell: UITableViewCell {
    
    var drug: DrugObject?
    var delegate: DrugDelegate?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        if let drug = drug {
            delegate?.delete(with: drug.id)
        }
    }
}
