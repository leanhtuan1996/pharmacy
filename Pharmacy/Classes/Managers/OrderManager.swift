//
//  OrderManager.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class Order: NSObject, NSCoding {
    var idDrug: Int
    var quantity: Int
    
    init(idDrug: Int, quantity: Int) {
        self.idDrug = idDrug
        self.quantity = quantity
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder){
        let idDrug = aDecoder.decodeInteger(forKey: "idDrug")
        let quantity = aDecoder.decodeInteger(forKey: "quantity")
        
        self.init(idDrug: idDrug, quantity: quantity)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(idDrug, forKey: "idDrug")
        aCoder.encode(quantity, forKey: "quantity")
    }
}

class OrderManager: NSObject {
    static let shared = OrderManager()
    let userDefaults = UserDefaults.standard
    
    func addToCart(with orderObject: Order?, completionHandled: @escaping (_ isSuccess: Bool, _ error: String?) -> Void) {
        
        
        var ordersArray:[Order] = []
        
        //zip Order to NSUserDefaults
        if let order = orderObject {
            //Append new a element order to orders
            ordersArray.append(order)
            //print("ID: \(order.id), QUANTITY: \(order.quantity)")
        } else {
            completionHandled(false, "ORDER NOT FOUND!")
        }
        
        //Get orders from NSUserDefault
        if let data = userDefaults.object(forKey: "Orders") as? Data {
            //print(data)
            if let orders = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Order] {
                print(orders)
                for order in orders {
                    ordersArray.append(order)
                }
            }
        }
        
        //Set orders to NSUserDefault
        let ordersEncode:Data = NSKeyedArchiver.archivedData(withRootObject: ordersArray)
        userDefaults.set(ordersEncode, forKey: "Orders")
        userDefaults.synchronize()
        print("ADD TO CART OKAY")
        completionHandled(true, nil)
    }
    
    func getAllOrdersFromCart(completionHanler: @escaping (_ isSuccess: Bool, _ data: DrugObject?, _ error: String?) -> Void) {
        
        //Get Drugs-id in Cart
        var ordersArray:[Order] = []
        
            //Get orders from NSUserDefault
        if let data = userDefaults.object(forKey: "Orders") as? Data {
            //print(data)
            if let orders = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Order] {
                for order in orders {
                    ordersArray.append(order)
                }
            }
        }
        
        //Call to DrugsService with getDrug function
        
        for drugId in ordersArray {
            DrugsService.shared.getDrug(drugId: drugId.idDrug, completionHandler: { (isSuccess, drug, error) in
                if isSuccess {
                    if let drug = drug {
                        completionHanler(true, drug, nil)
                    } else {
                        completionHanler(false, nil, "ERROR")
                    }
                } else {
                    if let err = error {
                        completionHanler(false, nil, err)
                    } else {
                        completionHanler(false, nil, "ERROR")
                    }
                }
            })
        }
    }
    
    func checkOut(completionHandler: @escaping (_ isSuccsess: Bool, _ Error: String?) -> Void) {
        
        //Call to OrderService with newOrder function
        var ordersArray: [Order] = []
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "mm/dd/yyyy"
        let dateOrder = formater.string(from: date)
        
        //Get users from NSUserDefault
        if let data = userDefaults.object(forKey: "Orders") as? Data {
            if let orders = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Order] {
                for order in orders {
                    ordersArray.append(order)
                }
            }
        }
        
        if ordersArray.count == 0 {
            completionHandler(false, "ORDERS ARE EMPTY")
        }
        
        let parameter: [String : Any] = [
            "drugs" : ordersArray,
            "date": dateOrder
        ]

        OrderService.shared.newOrder(parameter: parameter) { (isSuccess, error) in
            //- if success: Delete all order in NSUserDefaults
            if isSuccess {
                self.userDefaults.removeObject(forKey: "Orders")
                completionHandler(true, nil)
            } else {
                if let err = error {
                    completionHandler(false, err)
                } else {
                    completionHandler(false, "ERROR")
                }
            }
        }
    }
}
