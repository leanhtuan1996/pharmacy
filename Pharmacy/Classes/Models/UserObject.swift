//
//  UserObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

enum userRole: String {
    case customer = "customer"
    case admin = "admin"
}

class UserObject: NSObject {
    var email: String
    var password: String?
    var fullName: String?
    var address: String?
    var phoneNumber: String?
    var role: userRole?
    var token: String?
    
    init(email: String) {
        self.email = email
        self.role = userRole.customer
    }
    
    required init?(json: JSON) {
        self.email = "email" <~~ json ?? "N/A"
        self.password = "password" <~~ json
        self.fullName = "fullname" <~~ json
        self.address = "address" <~~ json
        self.phoneNumber = "phonenumber" <~~ json
        self.role =   "role" <~~ json
        self.password = "password" <~~ json
        self.token = "token" <~~ json
    }
}
