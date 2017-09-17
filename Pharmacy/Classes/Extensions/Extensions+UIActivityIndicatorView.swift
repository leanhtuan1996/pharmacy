//
//  Extensions+UIActivityIndicatorView.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/17/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func showLoadingDialog(toVC: UIViewController) {
        
        self.activityIndicatorViewStyle = .whiteLarge
        self.color = UIColor.white
        toVC.view.addSubview(self)
        self.frame = toVC.view.bounds
        self.center = toVC.view.center
        self.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        self.startAnimating()
    }
    
    func stopLoadingDialog() {
        self.stopAnimating()
    }
}
