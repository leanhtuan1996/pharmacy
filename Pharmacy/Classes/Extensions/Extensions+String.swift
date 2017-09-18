//
//  Extensions+String.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func jsonDateToDate() -> String {
        //convert JSON datetime to date`
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let dateFormatted = dateFormatter.date(from: self) {
            //convert date to "yyyy-MM-dd" format
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: dateFormatted)
        } else {
            return ""
        }
    }
}

