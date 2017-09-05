//
//  DrugCell.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugCell: UITableViewCell {
    
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var lblFormula: UILabel!
    @IBOutlet weak var lblContraindication: UILabel!
    @IBOutlet weak var lblSideEffect: UILabel!
    @IBOutlet weak var lblHowToUse: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
