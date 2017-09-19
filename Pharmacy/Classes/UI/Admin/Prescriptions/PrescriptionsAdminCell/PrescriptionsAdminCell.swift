//
//  PrescriptionsAdminCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PrescriptionsAdminCell: UITableViewCell {

    var prescription: PrescriptionObject?
    var delegate: PrescriptionReviewHandler?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateCreated: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnRejectClicked(_ sender: Any) {
        if let prescription = prescription {
            delegate?.reject(withId: prescription.id)
        }
    }
    @IBAction func btnAcceptClicked(_ sender: Any) {
        if let prescription = prescription {
            delegate?.accept(withId: prescription.id)
        }
    }
    
}
