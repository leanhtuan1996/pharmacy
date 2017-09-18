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
    
    func showStoryBoard(vc: UIViewController?) {
        if let vc = vc {
            present(vc, animated: true, completion: nil)
        }
    }
}
