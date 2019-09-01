//
//  RestaurantUser.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/26/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class RestaurantUser: NSObject, Codable, NSCoding{
    var id : Int
    var restaurantName : String
    var restaurantAddress : String
    var restaurantEmail : String
    var restaurantLogo : String
    var billingAccountNumber : Int

    init(id : Int, restaurantName : String, restaurantAddress : String, restaurantEmail : String, restaurantLogo : String, billingAccountNumber : Int){
        self.id = id
        self.restaurantName = restaurantName
        self.restaurantAddress = restaurantAddress
        self.restaurantEmail = restaurantEmail
        self.restaurantLogo = restaurantLogo
        self.billingAccountNumber = billingAccountNumber
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(restaurantName, forKey: "restaurantName")
        aCoder.encode(restaurantAddress, forKey: "restaurantAddress")
        aCoder.encode(restaurantEmail, forKey: "restaurantEmail")
        aCoder.encode(restaurantLogo, forKey: "restaurantLogo")
        aCoder.encode(billingAccountNumber, forKey: "billingAccountNumber")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let restaurantName = aDecoder.decodeObject(forKey: "restaurantName") as! String
        let restaurantAddress = aDecoder.decodeObject(forKey: "restaurantAddress") as! String
        let restaurantEmail = aDecoder.decodeObject(forKey: "restaurantEmail") as! String
        let restaurantLogo = aDecoder.decodeObject(forKey: "restaurantLogo") as! String
        let billingAccountNumber = aDecoder.decodeInteger(forKey: "billingAccountNumber")
        self.init(id : id, restaurantName : restaurantName, restaurantAddress : restaurantAddress, restaurantEmail : restaurantEmail, restaurantLogo : restaurantLogo, billingAccountNumber : billingAccountNumber)
        
    }
    
    
}
