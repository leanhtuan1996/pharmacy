//
//  Extensions+HTTPURLResponse.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    func isServerNotFound() -> Bool {
        return self.statusCode == 404
    }
    
    func isInternalError() -> Bool {
        return self.statusCode == 500
    }
}
