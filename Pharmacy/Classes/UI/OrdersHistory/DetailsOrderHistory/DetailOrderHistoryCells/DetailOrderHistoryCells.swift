//
//  DetailOrderHistoryCells.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DetailOrderHistoryCells: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
