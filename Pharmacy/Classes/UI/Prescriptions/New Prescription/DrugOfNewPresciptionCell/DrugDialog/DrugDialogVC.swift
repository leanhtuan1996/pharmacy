
//
//  DrugDialogVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DrugDialogVC: UIViewController {

    var idDrug: Int?
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
        txtSoLuong.text = "1"
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.8)
        //UserDefaults.standard.removeObject(forKey: "Orders")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnCancelClicked(_ sender: Any) {
        self.view.removeFromSuperview()
    }
   
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
    @IBAction func btnAddToCartClicked(_ sender: Any) {
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.white
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.bounds
        activityIndicatorView.center = self.view.center
        activityIndicatorView.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        activityIndicatorView.startAnimating()
        
        //Gồm thuốc + số lượng
        guard let idDrug = idDrug, let quantity = Int(txtSoLuong.text!) else {
            return
        }        
        
        OrderManager.shared.addToCart(with: Order(idDrug: idDrug, quantity: quantity), completionHandled: { (error) in
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            if let error = error {
                alert.title = "Error"
                alert.message = error
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (btn) in
                    self.view.removeFromSuperview()
                }))
            } else {
                alert.title = "Successfully"
                alert.message = "Add to cart Successfully"
                alert.addAction(UIAlertAction(title: "Continue to buy", style: .default, handler: { (btn) in
                    self.view.removeFromSuperview()
                }))
            }
            
            self.showStoryBoard(alert)
        })
        
    }
}
