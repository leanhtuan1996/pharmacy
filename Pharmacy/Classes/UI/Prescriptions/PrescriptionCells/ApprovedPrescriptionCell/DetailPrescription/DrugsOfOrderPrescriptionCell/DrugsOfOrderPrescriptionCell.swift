//
//  DrugsOfOrderPrescriptionCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/17/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugsOfOrderPrescriptionCell: UITableViewCell {

    var drug: DrugObject?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    
    var delegate: ActionWhenChooseDrug?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func btnIncreaseClicked(_ sender: Any) {
        
        if let soluong = lblQuantity.text, let soluongInt = Int(soluong) {
            
            if soluong.isEmpty || soluongInt == 0 {
                lblQuantity.text = "1"
                
            } else {
                lblQuantity.text = String(Int(soluong)! + 1)
            }
            
            if let drug = drug {
                drug.quantity = soluongInt + 1
                //delegate?.addDrug(with: drug)
            }
        }
        
    }
    @IBAction func btnDecreaseClicked(_ sender: Any) {
        if let soluong = lblQuantity.text, let soluongInt = Int(soluong) {
            
            if soluongInt == 0 {
                return
            } else {
                lblQuantity.text = String(Int(soluong)! - 1)
            }
            
            if let drug = drug {
                drug.quantity = soluongInt - 1
                //delegate?.addDrug(with: drug)
            }
        }
    }
    
}
