//
//  DrugNetworking.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum DrugRouter: URLRequestConvertible {
    
    //Action
    case getDrug([String: Any])
    case listOfDrug()
    case search([String: Any])
    
    //Admin for admin
    case addNewDrug([String : String])
    case updateDrug([String : Any])
    case deleteDrug([String : Any])
    
    //Variable Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getDrug:
            return .post
        case .listOfDrug:
            return .get
        case .addNewDrug:
            return .post
        case .updateDrug:
            return .post
        case .deleteDrug:
            return .post
        case .search:
            return .post
        }
    }
    
    //Variable Path
    var path: String {
        switch self {
        case .getDrug:
            return "/getDrug"
        case .listOfDrug:
            return "/listOfDrug"
        case .addNewDrug:
            return "/admin/addNewDrug"
        case . updateDrug:
            return "/admin/updateDrug"
        case .deleteDrug:
            return "/admin/deleteDrug"
        case .search:
            return "/searching"
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
        case .getDrug(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .listOfDrug():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .addNewDrug(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateDrug(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .deleteDrug(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .search(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
    }
    
}
