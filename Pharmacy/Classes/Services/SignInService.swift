//
//  SignInService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
typealias JSON = [String: Any]

class SignInService: NSObject {
    static let shared = SignInService()
    
    let userDefaults = UserDefaults.standard
    
    func signIn(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ token: String?, _ error: String?) -> ()) {
        
        let parameters = [
            "email" : email,
            "password" : password
        ]
        
        Alamofire.request("http://35.177.230.252:3000/signin", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .validate()
            .response { (response) in
            if let error = response.error {
                let errorString = handleError(response: response.response, error: error as NSError)
                completionHandler(false, nil, errorString)
                return
            }
            
                //parse data to json
                if let json = (response.data! as NSData).toDictionary() {
                    print((json["token"] as? [String])?.count)
                    
                    if let token = json["token"] as? String {
                        print(token.isEmpty)
                        if token.isEmpty {  //login error
                            if let error = json["errors"] as? String {
                                completionHandler(false, nil, error)
                            } else {
                                completionHandler(false, nil, "Not found Error")
                            }
                        } else {
                            
                            completionHandler(true, json["token"] as? String, nil)
                        }
                    }
                } else {
                    print("Response is not corrected formation")
                }
        }
        
    }
}

func handleError(response: HTTPURLResponse?, error: NSError) -> String {
    if error.isNoInternetConnectionError() {
        print("No Internet Connection")
        return "No Internet Connection"
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

extension NSObject {
    func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}

extension NSData {
    func toDictionary() -> [String: Any]? {
        
        do {
            return try JSONSerialization.jsonObject(with: self as Data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        
        return nil

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
