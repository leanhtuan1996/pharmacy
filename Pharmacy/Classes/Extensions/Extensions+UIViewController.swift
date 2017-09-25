//
//  Extensions+UIViewController.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/18/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showStoryBoard(_ vc: UIViewController?) {
        if let vc = vc {
            present(vc, animated: true, completion: nil)
        }
    }
    
    func showAlert(_ message:String, title: String, buttons: [UIAlertAction]?) {
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let buttons = buttons {
            for button in buttons {
                alert.addAction(button)
            }
        } else {
            alert.addAction(.init(title: "Okay", style: .default, handler: nil))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.layer.zPosition = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.view.addSubview(blurEffectView)
    }
    
}
