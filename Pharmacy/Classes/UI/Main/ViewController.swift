//
//  ViewController.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnUpdatePwClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "changePwVC") as? ChangePwVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnUpdateInfoClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "changeInfoVC") as? ChangeInfoVC {
             navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnGetInfoClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GetInformationsVC") as? GetInformationsVC {
         navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnOrderDrugClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OrderDrugVC") as? OrderDrugVC {
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func btnLogoutClicked(_sender: Any) {
        appDelegate?.SignOut()
    }
    
    @IBAction func btnOrdersHistoryClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryVC") as? OrderHistoryVC {
             navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

