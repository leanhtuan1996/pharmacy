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
    
    //add drug to cart
    func addToCart(with orderObject: Order?, completionHandled: @escaping (_ error: String?) -> Void) {
        
        var ordersArray:[Order] = []
        
        //zip Order to NSUserDefaults
        if let order = orderObject {
            //Append new a element order to orders
            ordersArray.append(order)
            //print("ID: \(order.id), QUANTITY: \(order.quantity)")
        } else {
            return completionHandled("ORDER NOT FOUND!")
        }
        
        //Get orders from NSUserDefault
        if let data = userDefaults.object(forKey: "Orders") as? Data {
            //print(data)
            if let orders = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Order] {
                //print(orders)
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
        return completionHandled(nil)
    }
    
    //get all order from NSUSERDEFAULTS to show in my cart
    func getAllOrdersFromCart(completionHandler: @escaping (_ drug: DrugObject?, _ error: String?) -> Void) {
        
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
        
        for drugOrder in ordersArray {
            DrugsService.shared.getDrug(drugId: drugOrder.idDrug, completionHandler: { (drug, error) in
                if let error = error {
                    return completionHandler(nil, error)
                } else {
                    if let drug = drug {
                        drug.quantity = drugOrder.quantity
                        return completionHandler(drug, nil)
                    } else {
                        return completionHandler(nil, "ERROR")
                    }
                }
            })
        }
    }
    
    //ORDER DRUGS
    func checkOut(drugToOrders: [DrugObject], completionHandler: @escaping (_ Error: String?) -> Void) {
        
        if drugToOrders.count == 0 {
            return
        }
        
        //Call to OrderService with newOrder function
        var ordersArray: [[String : Any]] = []
        
        let dateOrder = Date.getDate()
        
        for drug in drugToOrders {
            
            let dict: [String: Any] = [
                "id" : drug.id,
                "quantity" : drug.quantity
            ]
            
            ordersArray.append(dict)
        }
       
        
        let parameter: [String : Any] = [
            "drugs" : ordersArray,
            "date": dateOrder
        ]
        
        OrderService.shared.newOrder(parameter: parameter) { (error) in
           
            if let error = error {
                return completionHandler(error)
            } else {
                self.userDefaults.removeObject(forKey: "Orders")
                return completionHandler(nil)
            }
        }
    }
}
