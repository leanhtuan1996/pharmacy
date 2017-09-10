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
    
    func getOrder(parameter: [String: Int], completionHandler: @escaping (_ isSuccess: Bool, _ order: OrderObject?, _ error: String?) -> Void)
    {
        
//        {
//            "orderNumber": 4,
//            "customerId": "5",
//            "date": "2017-09-04T00:00:00.000Z",
//            "totalPrice": 40,
//            "drugs": [
//            {
//            "id_drug": 1,
//            "quantity": 10,
//            "unit_price": 3
//            },
//            {
//            "id_drug": 2,
//            "quantity": 10,
//            "unit_price": 1
//            }
//            ]
//        }
        
        Alamofire.request(OrderRouter.getOrder(parameter))
        .validate()
        .response { (res) in
            
            if let err = res.error {
                completionHandler(false, nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                return
            }
            
            if let data = res.data {
                if let json = (data as NSData).toDictionary() {
                    if let error = json["errors"] as? [String] {
                        print(error)
                        if error.count > 0 {
                            completionHandler(false, nil, error[0])
                            return
                        }
                    }
                    
                    guard let id = json["orderNumber"] as? Int, let date = json["date"] as? String, let totalPrice = json["totalPrice"] as? Int, let drugs = json["drugs"] as? [AnyObject] else {
                        completionHandler(false, nil, "Invalid data format")
                        return
                    }
                    
                    
                    var drugArray: [DrugObject] = []
                    
                    for drugData in drugs {
                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
                            
                            guard let id = drugObject["id"] as? Int, let unit_price = drugObject["unit_price"] as? Int, let quantity = drugObject["quantity"] as? Int else {
                                completionHandler(false, nil, "Invalid data format")
                                return
                            }
                            
                            let temp = DrugObject(id: id, name: "", instructions: "", formula: "", contraindication: "", sideEffect: "", howToUse: "", price: unit_price)
                            temp.quantity = quantity
                            
                            drugArray.append(temp)
                            
                        } else {
                            completionHandler(false, nil, "Invalid data format")
                            return
                        }
                    }
                    
                    completionHandler(true, OrderObject(id: id, date: date, totalPrice: totalPrice, drugs: drugArray), nil)
                    
                } else {
                    completionHandler(false, nil, "Invalid data format")
                    return
                }
                
            } else {
                completionHandler(false, nil, "Invalid data format")
                return
            }
        }
        
    }
    //ADMIN
    func getAllOrder(completionHandler: @escaping (_ isSuccess: Bool, _ order: [OrderObject?], _ error: String?) -> Void) {
        Alamofire.request(OrderRouter.getAllOrders())
        .validate()
        .response { (res) in
            completionHandler(false, [nil], "ERROR GET ALL OREDER")
        }
    }
    
    func newOrder(parameter: [String : Any], completionHandler: @escaping (_ isSuccess: Bool, _ error: String?) -> Void) {
        
        Alamofire.request(OrderRouter.newOrder(parameter))
        .validate()
        .response { (res) in
            
            if let err = res.error {
                completionHandler(false, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                return
            }
            
            if let data = res.data {
                if let json = (data as NSData).toDictionary() {
                    
                    if let error = json["errors"] as? [String] {
                       
                        if error.count > 0 {
                            print(error)
                            completionHandler(false, error[0])
                            return
                        } else {
                            completionHandler(true, nil)
                            return
                        }
                    } else {
                        completionHandler(true, nil)
                    }
                    
                } else {
                    completionHandler(false,  "Invalid data format")
                    return
                }
                
            } else {
                completionHandler(false,  "Invalid data format")
                return
            }
        }
        
    }
    
    
    func getOrdersHistory(completionHandler: @escaping (_ isSuccess: Bool, _ order: [OrderObject?], _ error: String?) -> Void) {

        
        Alamofire.request(OrderRouter.getOrderHistory())
        .validate()
        .response { (res) in
            if let err = res.error {
                completionHandler(false, [nil], NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                return
            }
            
            if let data = res.data {
                if let json = (data as NSData).toDictionary() {
                    if let error = json["errors"] as? [String] {
                        
                        if error.count > 0 {
                            print(error)
                            completionHandler(false, [nil], error[0])
                            return
                        }
                    }
                    
                    guard let allOrderJson = json["allOrder"] as? [AnyObject] else {
                        print("1")
                        completionHandler(false, [nil], "Invalid data format")
                        return
                    }
                    
                    var ordersHistory: [OrderObject] = []
                    
                    for orderData in allOrderJson {
                        if let order = Utilities.convertObjectToJson(object: orderData) {
                            
                            guard let id = order["id"] as? Int, var date = order["date"] as? String, let total_price = order["total_price"] as? Int else {
                                print("2")
                                completionHandler(false, [nil], "Invalid data format")
                                return
                            }
                            
                            //convert JSON datetime to date
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            if let dateFormatted = dateFormatter.date(from: date) {
                                //convert date to "yyyy-MM-dd" format
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                date = dateFormatter.string(from: dateFormatted)
                            } else {
                                date = ""
                            }
                            
                            ordersHistory.append(OrderObject(id: id, date: date, totalPrice: total_price, drugs: []))
                            
                        } else {
                            print("3")
                            completionHandler(false, [nil], "Invalid data format")
                            return
                        }
                    }
                    
                    completionHandler(true, ordersHistory, nil)
                    
                } else {
                    print("4")
                    completionHandler(false, [nil], "Invalid data format")
                    return
                }
                
            } else {
                print("5")
                completionHandler(false, [nil], "Invalid data format")
                return
            }
        }
        
    }
    
    func getDetailOrder(id: Int, completionHandler: @escaping (_ isSuccess: Bool, _ order: OrderObject?, _ error: String?) -> Void) {
        
        let parameters = [
            "orderId" : id
        ]
        
        Alamofire.request(OrderRouter.getDetailOrder(parameters))
        .validate()
        .response { (res) in
//            {
//                "orderNumber": 4,
//                "customerId": "5",
//                "date": "2017-09-04T00:00:00.000Z",
//                "totalPrice": 40,
//                "drugs": [
//                {
//                "id_drug": 1,
//                "quantity": 10,
//                "unit_price": 3
//                },
//                {
//                "id_drug": 2,
//                "quantity": 10,
//                "unit_price": 1
//                }
//                ]
//            }
            
            if let err = res.error {
                completionHandler(false, nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                return
            }
            
            if let data = res.data {
                if let json = (data as NSData).toDictionary() {
                    
                    if let error = json["errors"] as? [String] {
                        print(error)
                        if error.count > 0 {
                            completionHandler(false, nil, error[0])
                            return
                        }
                    }
                    
                    guard let id = json["orderNumber"] as? Int, let date = json["date"] as? String, let totalPrice = json["totalPrice"] as? Int, let drugs = json["drugs"] as? [AnyObject] else {
                        completionHandler(false, nil, "Invalid data format")
                        return
                    }
                    
                    var drugArray: [DrugObject] = []
                    
                    for drugData in drugs {
                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
                            
                            guard let id = drugObject["id_drug"] as? Int, let quantity = drugObject["quantity"] as? Int, let unit_price = drugObject["unit_price"] as? Int else {
                                completionHandler(false, nil, "Invalid data format")
                                return
                            }
                            
                            let drug = DrugObject(id: id, name: "", instructions: "", formula: "", contraindication: "", sideEffect: "", howToUse: "", price: unit_price)
                            drug.quantity = quantity
                            
                            drugArray.append(drug)
                            
                        } else {
                            completionHandler(false, nil, "Invalid data format")
                            return
                        }
                    }
                    
                    completionHandler(true, OrderObject(id: id, date: date, totalPrice: totalPrice, drugs: drugArray), nil)
                    
                } else {
                    completionHandler(false, nil, "Invalid data format")
                    return
                }
                
            } else {
                completionHandler(false, nil, "Invalid data format")
                return
            }

        }
    }
}
