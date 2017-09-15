//
//  PrescriptionCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/13/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PrescriptionCell: UITableViewCell {
    var id: Int?
    var delegate: DeletePrecription?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateCreated: UILabel!
    @IBOutlet weak var lblTotalDrugs: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDeletePrescription(_ sender: Any) {
        
        if let id = id {
            PrescriptionManager.shared.deletePresciption(id: id, completionHandler: { (error) in
                if let error = error {
                    print("DELETE FAILED: \(error)")
                    return
                }
                //call func protocol
                self.delegate?.deletePre(with: id)
            })
        } else {
            print("DELETE FAILED")
        }
    }
}
