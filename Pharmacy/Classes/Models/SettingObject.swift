//
//  SettingObject.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/19/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

enum SettingType: String {
    case logout = "logout"
    case updatePw = "UpdatePw"
}

class SettingObject: NSObject {
    var img:String?
    var name:String?
    var type: SettingType
    
    init(img: String, name: String, type: SettingType) {
        self.img = img
        self.name = name
        self.type = type
    }    
}
