//
//  Extensions+NSError.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation

extension NSError {
    func isNoInternetConnectionError() -> Bool {
        return (self.domain == NSURLErrorDomain && (self.code == NSURLErrorNotConnectedToInternet || self.code == NSURLErrorNetworkConnectionLost || self.code == NSURLErrorCannotConnectToHost));
    }
    
    func isRequestTimeOutError() -> Bool {
        return self.code == NSURLErrorTimedOut
    }
}
