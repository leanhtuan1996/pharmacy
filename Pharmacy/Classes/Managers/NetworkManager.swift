//
//  NetworkManager.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/21/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    //Handled Error
    func handleError(response: HTTPURLResponse?, error: NSError) -> String {
        
        guard let res = response else {
            return "Error not found"
        }
        
        if error.isNoInternetConnectionError() {
            print("Internet Connection Error")
            return "Internet Connection Error"
        } else if error.isRequestTimeOutError() {
            print("Request TimeOut")
            return "Request TimeOut"
        } else if res.isServerNotFound() {
            print("Server not found")
            return "Server not found"
        } else if res.isInternalError() {
            print("Internal Error")
            return "Internal Error"
        }
        return "Error Not Found"
    }
}

extension NSError {
    func isNoInternetConnectionError() -> Bool {
        return (self.domain == NSURLErrorDomain && (self.code == NSURLErrorNotConnectedToInternet || self.code == NSURLErrorNetworkConnectionLost || self.code == NSURLErrorCannotConnectToHost));
    }
    
    func isRequestTimeOutError() -> Bool {
        return self.code == NSURLErrorTimedOut
    }
}

extension HTTPURLResponse {
    func isServerNotFound() -> Bool {
        return self.statusCode == 404
    }
    
    func isInternalError() -> Bool {
        return self.statusCode == 500
    }
}

