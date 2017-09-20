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
    
//    func getOrder(_ parameter: [String: Int], completionHandler: @escaping (_ order: OrderObject?, _ error: String?) -> Void)
//    {
//        Alamofire.request(OrderRouter.getOrder(parameter))
//        .validate()
//        .response { (res) in
//            
//            if let err = res.error {
//                return completionHandler(nil, Utilities.handleError(res.response, error: err as NSError))
//                
//            }
//            
//            if let data = res.data {
//                if let json = data.toDictionary() {
//                    if let error = json["errors"] as? [String] {
//                        print(error)
//                        if error.count > 0 {
//                            return completionHandler(nil, error[0])
//                        }
//                    }
//                    
//                    guard let id = json["orderNumber"] as? Int, let drugs = json["drugs"] as? [AnyObject] else {
//                        return completionHandler(nil, "Invalid data format")
//                    }
//                    
//                    let orderObject = OrderObject(id: id, drugs: [])
//                    
//                    if  let date = json["date"] as? String {
//                        orderObject.date = date.jsonDateToDate()
//                    }
//                    
//                    
//                    var drugArray: [DrugObject] = []
//                    
//                    for drugData in drugs {
//                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
//                            guard let id = drugObject["id"] as? Int, let quantity = drugObject["quantity"] as? Int else {
//                                return completionHandler(nil, "Invalid data format")
//                            }
//                            
//                            let drugObject = DrugObject()
//                            drugObject.id = id
//                            drugObject.quantity = quantity
//                            
//                            drugArray.append(drugObject)
//                        } else {
//                            return completionHandler(nil, "Invalid data format")
//                        }
//                    }
//                    return completionHandler(orderObject, nil)
//                } else {
//                    return completionHandler(nil, "Invalid data format")
//                }
//                
//            } else {
//                return completionHandler(nil, "Invalid data format")
//            }
//        }
//        
//    }
    
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
                    
                    guard let allOrderJson = json["allOrder"] as? [AnyObject] else {
                        print("1")
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    var ordersHistory: [OrderObject] = []
                    
                    for orderData in allOrderJson {
                        if let order = Utilities.convertObjectToJson(object: orderData) {
//                            guard let id = order["id"] as? Int else {
//                                print("2")
//                                return completionHandler(nil, "Invalid data format")
//                            }
//                            
//                            let orderObject = OrderObject(id: id, drugs: [])
//                            
//                            if let date = order["date"] as? String {
//                                orderObject.date = date.jsonDateToDate()
//                            }
                            if let orderObject = OrderObject(json: order) {
                                ordersHistory.append(orderObject)
                            }
                        } else {
                            print("3")
                            return completionHandler(nil, "Invalid data format")
                        }
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
                    
//                    guard let idOrder = json["orderNumber"] as? Int, let drugs = json["drugs"] as? [AnyObject] else {
//                        return completionHandler(nil, "Invalid data format")
//                    }
//                    
//                    let orderObject = OrderObject(id: idOrder, drugs: [])
//                    
//                    if let date = json["date"] as? String {
//                        orderObject.date = date.jsonDateToDate()
//                    }
                    
                    guard let order = OrderObject(json: json) else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    return completionHandler(order, nil)
//                    var drugArray: [DrugObject] = []
//                    var flag = 0
                    
//                    for drugData in drugs {
//                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
//                            
//                            guard let id = drugObject["id_drug"] as? Int, let quantity = drugObject["quantity"] as? Int else {
//                                return completionHandler(nil, "Invalid data format")
//                            }
//                            
//                            //Get full drug info from ID
//                            DrugsService.shared.getDrug(id, completionHandler: { (drug, error) in
//                                
//                                if let error = error {
//                                    print("GET DRUG INFOMATION WITH ERROR: \(error)")
//                                    return completionHandler(nil, "Invalid data format")
//                                }
//                                
//                                if let drug = drug {
//                                    drug.quantity = quantity
//                                    drugArray.append(drug)
//                                    //print(drug.id)
//                                    flag = flag + 1
//                                } else {
//                                    print("GET DRUG INFOMATION ERROR")
//                                    return completionHandler(nil, "Invalid data format")
//                                }
//                                
//                                if flag == drugs.count {
//                                    orderObject.drugs = drugArray
//                                    return completionHandler(orderObject, nil)
//                                }
//                            })
//                        } else {
//                            return completionHandler(nil, "Invalid data format")
//                        }
//                    }
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
            } else {
                return completionHandler(nil, "Invalid data format")
            }

        }
    }
}
