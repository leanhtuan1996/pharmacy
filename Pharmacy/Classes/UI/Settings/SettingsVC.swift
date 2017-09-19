//
//  SettingsVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/19/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
   
    @IBOutlet weak var tblSettings: UITableView!
    var settings: [SettingObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        tblSettings.dataSource = self
        tblSettings.delegate = self
        tblSettings.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let nav = self.navigationController {
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.view.backgroundColor = .clear
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            
            if !nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    func loadSettings() {
        let updatePwSetting = SettingObject(img: "updatePw", name: "Update Password", type: SettingType.updatePw)
        let logoutSetting = SettingObject(img: "logout", name: "Log out", type: SettingType.logout)
        
        settings = [updatePwSetting, logoutSetting]
    }

}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        cell.btnSetting.setTitle(settings[indexPath.row].name, for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settings[indexPath.row].type {
        case .logout:
            print("logout")
        case .updatePw:
            print("updatePw")
        }
    }
}
