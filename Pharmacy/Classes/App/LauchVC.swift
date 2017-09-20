//
//  LauchVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class LauchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "Prescriptions")
        //check token in NSUserDefaults thì vào main
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            //appDelegate.SignOut()
            print(UserManager.shared.getToken() ?? "NIL")
            
            if UserManager.shared.isLoggedIn() {
                UserManager.shared.verifyToken({ ( role, error) in
                    if let error = error {
                        print(error)
                        appDelegate.showSignInView()
                    } else {
                        if let role = role {
                            switch role {
                            case .admin:
                                appDelegate.showAdminView()
                            case .customer:
                                appDelegate.showMainView()
                            }
                        }
                    }
                })
            } else {
                appDelegate.showSignInView()
            }
        }
    }
}
