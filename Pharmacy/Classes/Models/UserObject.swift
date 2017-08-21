//
//  UserObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

enum userRole {
    case customer
    case admin
    case manager
}

class UserObject: NSObject {
    var email: String
    var password: String
    var fullName: String
    var address: String
    var phoneNumber: String
    var role: userRole
    var token: String
    
    init(email: String, password: String, fullName: String, address: String, phoneNumber: String, token: String) {
        self.email = email
        self.password = password
        self.fullName = fullName
        self.address = address
        self.phoneNumber = phoneNumber
        self.token = token
        self.role = userRole.customer
    }
    
    
}
