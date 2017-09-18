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
        addToUserDefault(with: currentAllPrescriptions)
        print("ADD PRESCRIPTION TO NSUSERDEFAULTS SUCCESSFULLY")
        return completionHanler(nil)
    }
    
    func editPrescription(with prescription: PrescriptionObject, completionHanler: @escaping (_ error: String?) -> Void ) {
        //check if exist current
        if let index = currentAllPrescriptions.index(where: { (pre) -> Bool in
            return pre.id == prescription.id
        }) {
            //exist 
            currentAllPrescriptions[index] = prescription
            addToUserDefault(with: currentAllPrescriptions)
            return completionHanler(nil)
        } else {
            return completionHanler("Prescription not found")
        }
    }
    
    //get all prescriptions from userdefaults
    func getAllPrescription(completionHandler: @escaping(_ data: [PrescriptionObject]?, _ error: String?) -> Void ) {
        //Get orders from NSUserDefault
        if let data = userDefaults.object(forKey: "Prescriptions") as? Data {
            //print(data)
            if let prescriptions = NSKeyedUnarchiver.unarchiveObject(with: data) as? [PrescriptionObject] {
                currentAllPrescriptions = prescriptions
                //print(currentAllPrescriptions.count)
                return completionHandler(currentAllPrescriptions, nil)
                
            }
        }
    }
    
    func deletePresciption(withId id: Int, completionHandler: @escaping (_ error: String?) -> Void ) {
        //tìm theo id trong currentPre
        
        if let index = currentAllPrescriptions.index(where: { (pre) -> Bool in
            return pre.id == id
        }) {
            currentAllPrescriptions.remove(at: index)
            addToUserDefault(with: currentAllPrescriptions)
            return completionHandler(nil)
        } else {
            return completionHandler("Prescription not found")
        }
        
        //Xoá
        //Ghi lại vào userdefault
    }
    
    func addToUserDefault(with prescription: [PrescriptionObject] ) {
        //set to userdefault
        let prescriptionsEncode:Data = NSKeyedArchiver.archivedData(withRootObject: currentAllPrescriptions)
        userDefaults.set(prescriptionsEncode, forKey: "Prescriptions")
        userDefaults.synchronize()
        //print("ADD PRESCRIPTION TO NSUSERDEFAULTS SUCCESSFULLY")
    }
    
}
