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
    func addPrescription(with prescription: PrescriptionObject) {
        
        prescription.id = currentAllPrescriptions.count
        currentAllPrescriptions.append(prescription)
        addToUserDefault(with: currentAllPrescriptions)
        print("ADD PRESCRIPTION TO NSUSERDEFAULTS SUCCESSFULLY")
       
    }
    
    func editPrescription(with prescription: PrescriptionObject) -> Bool {
        //check if exist current
        if let index = currentAllPrescriptions.index(where: { (pre) -> Bool in
            return pre.id == prescription.id
        }) {
            //exist 
            currentAllPrescriptions[index] = prescription
            addToUserDefault(with: currentAllPrescriptions)
            return true
        } else {
            return false
        }
    }
    
    //get all prescriptions from userdefaults
    func getAllPrescription() -> [PrescriptionObject]? {
        //Get orders from NSUserDefault
        if let data = userDefaults.object(forKey: "Prescriptions") as? Data {
            //print(data)
            if let prescriptions = NSKeyedUnarchiver.unarchiveObject(with: data) as? [PrescriptionObject] {
                currentAllPrescriptions = prescriptions
                //print(currentAllPrescriptions.count)
                return prescriptions
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func deletePresciption(withId id: Int) -> Bool {
        //tìm theo id trong currentPre
        
        if let index = currentAllPrescriptions.index(where: { (pre) -> Bool in
            return pre.id == id
        }) {
            currentAllPrescriptions.remove(at: index)
            addToUserDefault(with: currentAllPrescriptions)
            return true
        } else {
            return false
        }
    }
    
    func addToUserDefault(with prescription: [PrescriptionObject] ) {
        //set to userdefault
        let prescriptionsEncode:Data = NSKeyedArchiver.archivedData(withRootObject: currentAllPrescriptions)
        userDefaults.set(prescriptionsEncode, forKey: "Prescriptions")
        userDefaults.synchronize()
        //print("ADD PRESCRIPTION TO NSUSERDEFAULTS SUCCESSFULLY")
    }
    
}
