//
//  PendingPrescriptionCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/16/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PendingPrescriptionCell: UITableViewCell {
    var prescription: PrescriptionObject?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTotalDrug: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
