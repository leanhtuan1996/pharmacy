//
//  Utilities.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/21/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    static func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    static func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    static func convertObjectToJson(object: AnyObject) -> [String: Any]? {
        do {
            
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                //print(JSONString)
            }
            
            return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
            
            
        } catch {
            return nil
        }
    }
    
    static func getDate() -> String {
        return "14/09/2017"
    }
}

extension NSData {
    func toDictionary() -> [String: Any]? {
        
        do {
            return try JSONSerialization.jsonObject(with: self as Data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
        
    }
}

extension UIViewController {
    
    func showStoryBoard(vc: UIViewController?) {
        if let vc = vc {
            present(vc, animated: true, completion: nil)
        }
    }
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
