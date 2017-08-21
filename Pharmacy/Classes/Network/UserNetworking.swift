//
//  UserNetworking.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/21/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

let baseURLString = "http://35.177.230.252:3000"

enum UserRouter: URLRequestConvertible {
    
    // Variables
    static var authToken: String?
    
    //Action
    case signIn([String: String])
    case signUp([String : String])
    
    //Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .signUp:
            return .post
        }
    }
    
    //Path
    var path: String {
        switch self {
        case .signIn:
            return "/signin"
        case .signUp:
            return "/signup"
        }
    }
    
    //Request
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURLString)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = UserRouter.authToken {
            urlRequest.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        
        switch self {
        case .signIn(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .signUp(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
