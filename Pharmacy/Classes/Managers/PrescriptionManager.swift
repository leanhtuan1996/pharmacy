//
//  PrescriptionManager.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/13/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PrescriptionManager: NSObject {
    static let shared = PrescriptionManager()
    
    let userDefaults = UserDefaults.standard
    
    var currentAllPrescriptions: [PrescriptionObject] = []
    
    //To prescription to userdefaults
    func addPrescription(with prescription: PrescriptionObject, completionHanler: @escaping (_ error: String?) -> Void) {
       
        prescription.id = currentAllPrescriptions.count
        currentAllPrescriptions.append(prescription)
        
        //set to userdefault
        let prescriptionsEncode:Data = NSKeyedArchiver.archivedData(withRootObject: currentAllPrescriptions)
        userDefaults.set(prescriptionsEncode, forKey: "Prescriptions")
        userDefaults.synchronize()
        print("ADD PRESCRIPTION TO NSUSERDEFAULTS SUCCESSFULLY")
        return completionHanler(nil)
    }
    
    //get all prescriptions from userdefaults
    func getAllPrescription(completionHandler: @escaping(_ data: [PrescriptionObject]?, _ error: String?) -> Void ) {
        //Get orders from NSUserDefault
        if let data = userDefaults.object(forKey: "Prescriptions") as? Data {
            //print(data)
            if let prescriptions = NSKeyedUnarchiver.unarchiveObject(with: data) as? [PrescriptionObject] {
                currentAllPrescriptions = prescriptions
                print(currentAllPrescriptions.count)
                return completionHandler(currentAllPrescriptions, nil)
                
            }
        }
    }
    
}
