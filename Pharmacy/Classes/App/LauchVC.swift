//
//  LauchVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class LauchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //check token in NSUserDefaults thì vào main
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //print(UserDefaults.standard.object(forKey: "token") as! String)
        
        if UserManager.shared.isLoggedIn() {
            appDelegate.showMainView()
        } else {
            appDelegate.showSignInView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
