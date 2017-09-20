//
//  SubmitPrescriptionCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/16/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SubmitPrescriptionCell: UITableViewCell {
    
    var prescription: PrescriptionObject?
    var delegate: ManagerPrescriptionCell?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateCreated: UILabel!
    @IBOutlet weak var lblTotalDrugs: UILabel!
    @IBOutlet weak var lblStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDeletePrescription(_ sender: Any) {
        
        if let prescription = prescription {
            guard let id = prescription.id else {
                return
            }
            
            if PrescriptionManager.shared.deletePresciption(withId: id) {
                print("Delete Ok")
                self.delegate?.deletePre(with: id)
            } else {
                print("DELETE FAILED")
            }
        } else {
            print("DELETE FAILED")
        }
    }
    
    @IBAction func btnEditPrescription(_ sender: Any) {
        
    }
    
    @IBAction func btnSubmitPrescription(_ sender: Any) {
        if let prescription = prescription {
            delegate?.submitPre(with: prescription)
        }
    }
    
}
