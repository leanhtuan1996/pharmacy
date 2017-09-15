//
//  DrugCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugCell: UITableViewCell {
    
    var drug: DrugObject?
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtQuantity: UILabel!
    
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
        
        if let soluong = txtQuantity.text, let soluongInt = Int(soluong) {
            
            if soluong.isEmpty || soluongInt == 0 {
                txtQuantity.text = "1"
                
            } else {
                txtQuantity.text = String(Int(soluong)! + 1)
            }
            
            if let drug = drug {
                drug.quantity = soluongInt + 1
                delegate?.changeProperty(with: drug)
            }
        }
        
    }
    @IBAction func btnDecreaseClicked(_ sender: Any) {
        if let soluong = txtQuantity.text, let soluongInt = Int(soluong) {
            
            if soluongInt == 0 {
                return
            } else {
                txtQuantity.text = String(Int(soluong)! - 1)
            }
            
            if let drug = drug {
                drug.quantity = soluongInt - 1
                delegate?.changeProperty(with: drug)
            }
        }
    }
    
}
