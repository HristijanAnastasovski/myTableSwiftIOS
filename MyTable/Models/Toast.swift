//
//  Toast.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/28/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class Toast: NSObject {
    class func showToast(message : String, viewController: UIViewController) {
        let toastLabel = UILabel(frame: CGRect(x: viewController.view.frame.size.width/2 - 150, y: 80, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        toastLabel.font = UIFont(name:"Helvetica", size: 15.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        viewController.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
