//
//  OrderNetworking.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

enum OrderRouter: URLRequestConvertible {
    
    //Action
    case getOrder([String: Int])
    case getAllOrders()
    case newOrder([String : Any])
    case getOrderHistory()
    case getDetailOrder([String : Int])
    
    //Variable Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getOrder:
            return .post
        case .getAllOrders:
            return .get
        case .newOrder:
            return .post
        case .getOrderHistory:
            return .get
        case .getDetailOrder:
            return .post
        }
    }
    
   
    
    
    //Variable Path
    var path: String {
        switch self {
        case .getOrder:
            return "/admin/get-order"
        case .getAllOrders:
            return "/admin/get-all-orders"
        case .newOrder:
            return "/new-order"
        case .getOrderHistory:
            return "/get-order-history"
        case .getDetailOrder:
            return "/get-detail-order"
        }
    }
    
    //Request
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: baseURLString)!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        if let token = authToken {
            urlRequest.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        
        switch self {
        case .getOrder(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .getAllOrders():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .newOrder(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getOrderHistory():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .getDetailOrder(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
    }
}
