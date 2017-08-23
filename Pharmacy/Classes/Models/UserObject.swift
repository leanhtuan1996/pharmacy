//
//  UserObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

enum userRole: String {
    case customer = "customer"
    case admin = "admin"
    case manager = "manager"
}

class UserObject: NSObject {
    var email: String
    var password: String
    var fullName: String
    var address: String
    var phoneNumber: String
    var role: userRole
    var token: String
    
    init(email: String, password: String, fullName: String, address: String, phoneNumber: String) {
        self.email = email
        self.password = password
        self.fullName = fullName
        self.address = address
        self.phoneNumber = phoneNumber
        self.token = ""
        self.role = userRole.customer
    }
    
    
}
