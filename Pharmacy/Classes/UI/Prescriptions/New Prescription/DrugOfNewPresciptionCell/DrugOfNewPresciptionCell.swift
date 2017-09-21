//
//  DrugCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugOfNewPresciptionCell: UITableViewCell {
    
    var drug: DrugObject?
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var switchSelected: UISwitch!
    
    var delegate: ActionWhenChooseDrugDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func switchSelected(_ sender: Any) {
        if let drug = drug {
            if switchSelected.isOn {
                delegate?.addDrug(with: drug)
                return
            }
            delegate?.delDrug(with: drug)
        }
    }
    
}

