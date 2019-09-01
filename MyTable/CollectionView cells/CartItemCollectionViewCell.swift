//
//  CartItemCollectionViewCell.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/30/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class CartItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
    
    var OnPlusBtnTapped : ((CartItemCollectionViewCell) -> Void)? = nil
    
    var OnMinusBtnTapped : ((CartItemCollectionViewCell) -> Void)? = nil
    
    
    @IBAction func plusBtnClick(_ sender: Any) {
        if let OnPlusBtnTapped = self.OnPlusBtnTapped {
            OnPlusBtnTapped(self)
        }
    }
    
    @IBAction func minusBtnClick(_ sender: Any) {
        if let OnMinusBtnTapped = self.OnMinusBtnTapped {
            OnMinusBtnTapped(self)
        }
    }
    
}
