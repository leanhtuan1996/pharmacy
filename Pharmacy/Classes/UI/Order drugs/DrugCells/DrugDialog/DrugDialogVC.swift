
//
//  DrugDialogVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugDialogVC: UIViewController {

    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblHDSD: UILabel!
    @IBOutlet weak var lblCongThuc: UILabel!
    @IBOutlet weak var lblChongChiDinh: UILabel!
    @IBOutlet weak var lblTacDungPhu: UILabel!
    @IBOutlet weak var lblCachSuDung: UILabel!
    @IBOutlet weak var lblDonGia: UILabel!
    @IBOutlet weak var txtSoLuong: UITextField!    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDialog.layer.cornerRadius = 5
        txtSoLuong.text = "0"
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnCancelClicked(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnGiamSoLuongClicked(_ sender: Any) {
        if let soluong = txtSoLuong.text {
            
            if soluong.isEmpty || soluong == "0" {
                txtSoLuong.text = "0"
            } else {
                txtSoLuong.text = String(Int(soluong)! - 1)
            }
        }
    }

    @IBAction func btnTangSoLuongClicked(_ sender: Any) {
        if let soluong = txtSoLuong.text {
            if soluong.isEmpty {
                txtSoLuong.text = "1"
            } else {
                txtSoLuong.text = String(Int(soluong)! + 1)
            }
        }
    }
}
