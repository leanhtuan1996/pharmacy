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
        if error.isNoInternetConnectionError() {
            print("Internet Connection Error")
            return "Internet Connection Error"
        } else if error.isRequestTimeOutError() {
            print("Request TimeOut")
            return "Request TimeOut"
        } else if response!.isServerNotFound() {
            print("Server not found")
            return "Server not found"
        } else if response!.isInternalError() {
            print("Internal Error")
            return "Internal Error"
        }
        return "Error Not Found"
        // Xử lý các user-define error khác
        // Unwrap data để không bị crash khi data `nil`
        //if let data = data {
        //    handleCustomError(error, data)
        //    return
        //}
        
        // Chỗ này dành cho lỗi trả về mà không có data, thường rất ít gặp nhưng cũng nên handle, có thể định nghĩa 1 static message để show lên
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

