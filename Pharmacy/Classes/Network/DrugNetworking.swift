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
    case getDrug([String: String])
    case listOfDrug()
    case addNewDrug([String : Any])
    case updateDrug([String : String])
    case deleteDrug([String : String])
    
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
        }
    }
    
    //Variable Path
    var path: String {
        switch self {
        case .getDrug:
            return "/get-drug"
        case .listOfDrug:
            return "/admin/list-of-drug"
        case .addNewDrug:
            return "/admin/add-new-drug"
        case . updateDrug:
            return "/admin/update-drug"
        case .deleteDrug:
            return "/admin/delete-drug"
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
        }
        
    }

}
