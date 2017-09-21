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
    
    //Action for Admin
    case getListPrescription()
    case appceptPrescription([String: Any])
    case rejectPrescription([String: Any])
    
    //Variable Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAllPrescription:
            return .get
        case .newPrescription:
            return .post
        case .getDetailPrescription:
            return .post
        case .getListPrescription:
            return .get
        case .appceptPrescription:
            return .post
        case .rejectPrescription:
            return .post
        }
    }
    
    //Variable Path
    var path: String {
        switch self {
        case .getAllPrescription:
            return "/getListPrescriptions"
        case .newPrescription:
            return "/newPrescription"
        case .getDetailPrescription:
            return "/getPrescriptionDetail"
        case .getListPrescription:
            return "/admin/getAllPrescriptions"
        case .appceptPrescription:
            return "/admin/acceptPrescription"
        case .rejectPrescription:
            return "/admin/rejectPrescription"
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
        case .getListPrescription():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .appceptPrescription(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .rejectPrescription(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
