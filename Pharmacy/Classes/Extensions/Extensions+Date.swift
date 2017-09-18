//
//  Extensions+Date.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation
import UIKit
extension Date {
    static func getDate() -> String {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        let dateOrder = formater.string(from: date)
        return dateOrder
    }
}
