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
    
    static func convertObjectToJson(object: Any) -> [String: Any]? {
        do {
            
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            //if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                //print(JSONString)
            //}
            
            return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
            
            
        } catch {
            return nil
        }
    }
    
    static func emptyMessage(activityIndicatorView:UIActivityIndicatorView, tableView:UITableView) {
        
        //let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.white
        //tableView.view.addSubview(activityIndicatorView)
        tableView.backgroundView = activityIndicatorView
        activityIndicatorView.frame = tableView.frame
        activityIndicatorView.center = tableView.center
        activityIndicatorView.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        activityIndicatorView.sizeToFit()
        activityIndicatorView.startAnimating()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
//        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
//        messageLabel.text = message
//        messageLabel.textColor = UIColor.black
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = NSTextAlignment.center
//        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
//        messageLabel.sizeToFit()
//        tableView.backgroundView = messageLabel;
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    static func getDate() -> String {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        let dateOrder = formater.string(from: date)
        return dateOrder
    }
    
    static func convertJsonDateToDate(with date: String) -> String {
        //convert JSON datetime to date`
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let dateFormatted = dateFormatter.date(from: date) {
            //convert date to "yyyy-MM-dd" format
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: dateFormatted)
        } else {
            return ""
        }
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
