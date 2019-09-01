//
//  CustomButton.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/25/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect){
        super.init(frame: frame)
        drawCustomButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        drawCustomButton()
    }
    
    func drawCustomButton(){
        
        
        setShadow()
        
        setTitleColor(UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1), for: .normal)
        backgroundColor = .white
        titleLabel?.font = UIFont(name:"Helvetica-Bold", size: 18.0)
        layer.cornerRadius = 10
        layer.borderWidth = 1.5
        
        layer.borderColor = UIColor.white.cgColor
        
    }
    
    private func setShadow(){
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    public func shake(){
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }


}
