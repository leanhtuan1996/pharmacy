//
//  PrescriptionNetworking.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/16/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

enum PrescriptionRouter: URLRequestConvertible {
    
    //Action
    case getAllPrescription()
    case getDetailPrescription([String: Any])
    case newPrescription([String : Any])
    
    //Variable Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAllPrescription:
            return .get
        case .newPrescription:
            return .post
        case .getDetailPrescription:
            return .post
        }
    }
    
    //Variable Path
    var path: String {
        switch self {
        case .getAllPrescription:
            return "/get-list-prescriptions"
        case .newPrescription:
            return "/new-prescription"
        case .getDetailPrescription:
            return "/get-prescription-detail"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURLString)!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        if let token = authToken
        {
            urlRequest.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        
        switch self {
        case .getAllPrescription():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .newPrescription(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getDetailPrescription(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
