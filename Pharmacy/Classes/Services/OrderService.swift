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
    
    func getOrder(parameter: [String: Int], completionHandler: @escaping (_ order: OrderObject?, _ error: String?) -> Void)
    {
        Alamofire.request(OrderRouter.getOrder(parameter))
        .validate()
        .response { (res) in
            
            if let err = res.error {
                return completionHandler(nil, Utilities.handleError(response: res.response, error: err as NSError))
                
            }
            
            if let data = res.data {
                if let json = data.toDictionary() {
                    if let error = json["errors"] as? [String] {
                        print(error)
                        if error.count > 0 {
                            return completionHandler(nil, error[0])
                        }
                    }
                    
                    guard let id = json["orderNumber"] as? Int, let date = json["date"] as? String, let totalPrice = json["totalPrice"] as? Int, let drugs = json["drugs"] as? [AnyObject] else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    
                    var drugArray: [DrugObject] = []
                    
                    for drugData in drugs {
                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
                            guard let id = drugObject["id"] as? Int, let unit_price = drugObject["unit_price"] as? Int, let quantity = drugObject["quantity"] as? Int else {
                                return completionHandler(nil, "Invalid data format")
                            }
                            
                            let drugObject = DrugObject()
                            drugObject.id = id
                            drugObject.price = unit_price
                            drugObject.quantity = quantity
                            
                            drugArray.append(drugObject)
                        } else {
                            return completionHandler(nil, "Invalid data format")
                        }
                    }
                    
                    return completionHandler(OrderObject(id: id, date: date, totalPrice: totalPrice, drugs: drugArray), nil)
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
                
            } else {
                return completionHandler(nil, "Invalid data format")
            }
        }
        
    }
    
    func newOrder(parameter: [String : Any], completionHandler: @escaping (_ error: String?) -> Void) {
        Alamofire.request(OrderRouter.newOrder(parameter))
        .validate()
        .response { (res) in
            
            if let err = res.error {
                return completionHandler(Utilities.handleError(response: res.response, error: err as NSError))
                
            }
            
            if let data = res.data {
                if let json = data.toDictionary() {
                    
                    if let error = json["errors"] as? [String] {
                        if error.count > 0 {
                            print(error)
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
    
    func getOrdersHistory(completionHandler: @escaping (_ order: [OrderObject?], _ error: String?) -> Void) {
        Alamofire.request(OrderRouter.getOrderHistory())
        .validate()
        .response { (res) in
            if let err = res.error {
                return completionHandler([nil], Utilities.handleError(response: res.response, error: err as NSError))
            }
            if let data = res.data {
                if let json = data.toDictionary() {
                    if let error = json["errors"] as? [String] {
                        if error.count > 0 {
                            print(error)
                            return completionHandler([nil], error[0])
                        }
                    }
                    
                    guard let allOrderJson = json["allOrder"] as? [AnyObject] else {
                        print("1")
                        return completionHandler([nil], "Invalid data format")
                    }
                    
                    var ordersHistory: [OrderObject] = []
                    
                    for orderData in allOrderJson {
                        if let order = Utilities.convertObjectToJson(object: orderData) {
                            guard let id = order["id"] as? Int, let date = order["date"] as? String, let total_price = order["total_price"] as? Int else {
                                print("2")
                                return completionHandler([nil], "Invalid data format")
                            }
                            ordersHistory.append(OrderObject(id: id, date: date.jsonDateToDate(), totalPrice: total_price, drugs: []))
                        } else {
                            print("3")
                            return completionHandler([nil], "Invalid data format")
                        }
                    }
                    return completionHandler(ordersHistory, nil)
                } else {
                    print("4")
                    return completionHandler([nil], "Invalid data format")
                }
            } else {
                print("5")
                return completionHandler([nil], "Invalid data format")
            }
        }
        
    }
    
    func getDetailOrder(id: Int, completionHandler: @escaping (_ order: OrderObject?, _ error: String?) -> Void) {
        
        let parameters = [
            "orderId" : id
        ]
        
        Alamofire.request(OrderRouter.getDetailOrder(parameters))
        .validate()
        .response { (res) in
            
            if let err = res.error {
                return completionHandler(nil, Utilities.handleError(response: res.response, error: err as NSError))
            }
            
            if let data = res.data {
                if let json = data.toDictionary() {
                    
                    if let error = json["errors"] as? [String] {
                        print(error)
                        if error.count > 0 {
                            return completionHandler(nil, error[0])
                            
                        }
                    }
                    
                    guard let idOrder = json["orderNumber"] as? Int, let date = json["date"] as? String, let totalPrice = json["totalPrice"] as? Int, let drugs = json["drugs"] as? [AnyObject] else {
                        return completionHandler(nil, "Invalid data format")
                        
                    }
                    
                    var drugArray: [DrugObject] = []
                    var flag = 0
                    
                    for drugData in drugs {
                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
                            
                            guard let id = drugObject["id_drug"] as? Int, let quantity = drugObject["quantity"] as? Int else {
                                return completionHandler(nil, "Invalid data format")
                                
                            }
                            
                            //Get full drug info from ID
                            DrugsService.shared.getDrug(drugId: id, completionHandler: { (drug, error) in
                                
                                if let error = error {
                                    print("GET DRUG INFOMATION WITH ERROR: \(error)")
                                    return completionHandler(nil, "Invalid data format")
                                }
                                
                                if let drug = drug {
                                    drug.quantity = quantity
                                    drugArray.append(drug)
                                    //print(drug.id)
                                    flag = flag + 1
                                } else {
                                    print("GET DRUG INFOMATION ERROR")
                                    return completionHandler(nil, "Invalid data format")
                                }
                                
                                if flag == drugs.count {
                                    //print(flag)
                                    return completionHandler(OrderObject(id: idOrder, date: date, totalPrice: totalPrice, drugs: drugArray), nil)
                                }
                            })
  
                        } else {
                            return completionHandler(nil, "Invalid data format")
                            
                        }
                        
                    }
                    
                    //completionHandler(true, OrderObject(id: id, date: date, totalPrice: totalPrice, drugs: drugArray), nil)
                    
                } else {
                    return completionHandler(nil, "Invalid data format")
                    
                }
                
            } else {
                return completionHandler(nil, "Invalid data format")
                
            }

        }
    }
}
