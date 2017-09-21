//
//  OrderService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire


class OrderService: NSObject {
    static let shared = OrderService()
    
    func newOrder(_ parameter: [String : Any], completionHandler: @escaping (_ error: String?) -> Void) {
        Alamofire.request(OrderRouter.newOrder(parameter))
        .validate()
        .response { (res) in
            
            if let err = res.error {
                return completionHandler(Utilities.handleError(res.response, error: err as NSError))
            }
            
            if let data = res.data {
                if let json = data.toDictionary() {
                    if let error = json["errors"] as? [String] {
                        if error.count > 0 {
                            return completionHandler(error[0])
                        }
                        return completionHandler(nil)
                    } else {
                        return completionHandler(nil)
                    }
                } else {
                    return completionHandler("Invalid data format")
                }
            } else {
                return completionHandler("Invalid data format")
            }
        }
    }
    
    func getOrdersHistory(_ completionHandler: @escaping (_ order: [OrderObject]?, _ error: String?) -> Void) {
        Alamofire.request(OrderRouter.getOrderHistory())
        .validate()
        .response { (res) in
            if let err = res.error {
                return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
            }
            if let data = res.data {
                if let json = data.toDictionary() {
                    if let error = json["errors"] as? [String] {
                        if error.count > 0 {
                            return completionHandler(nil, error[0])
                        }
                    }
                    
                    guard let allOrderJson = json["allOrder"] as? [[String: Any]], let ordersHistory = [OrderObject].from(jsonArray: allOrderJson) else {
                        print("1")
                        return completionHandler(nil, "Invalid data format")
                    }
                  
                    return completionHandler(ordersHistory, nil)
                } else {
                    print("4")
                    return completionHandler(nil, "Invalid data format")
                }
            } else {
                print("5")
                return completionHandler(nil, "Invalid data format")
            }
        }
    }
    
    func getDetailOrder(_ id: Int, completionHandler: @escaping (_ order: OrderObject?, _ error: String?) -> Void) {
        
        let parameters = [
            "orderId" : id
        ]
        
        Alamofire.request(OrderRouter.getDetailOrder(parameters))
        .validate()
        .response { (res) in
            
            if let err = res.error {
                return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
            }
            
            if let data = res.data {
                if let json = data.toDictionary() {
                    
                    if let error = json["errors"] as? [String] {
                        print(error)
                        if error.count > 0 {
                            return completionHandler(nil, error[0])
                        }
                    }

                    guard let order = OrderObject(json: json) else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    return completionHandler(order, nil)

                } else {
                    return completionHandler(nil, "Invalid data format")
                }
            } else {
                return completionHandler(nil, "Invalid data format")
            }

        }
    }
}
