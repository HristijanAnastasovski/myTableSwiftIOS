//
//  OrderedMenuItem.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/30/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class OrderedMenuItem: NSObject, Codable, NSCoding {
    var id: Int
    var itemName: String
    var itemShortDescription: String
    var price: Double
    var quantityOrdered: Int
    var menuImage: String
    var restaurantId: Int
    
    init(id : Int, itemName : String, itemShortDescription : String, price : Double, quantity : Int, menuImage : String, restaurantId: Int){
        self.id = id
        self.itemName = itemName
        self.itemShortDescription = itemShortDescription
        self.price = price
        self.quantityOrdered = quantity
        self.menuImage = menuImage
        self.restaurantId = restaurantId
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "menuItemId")
        aCoder.encode(itemName, forKey: "itemName")
        aCoder.encode(itemShortDescription, forKey: "itemShortDescription")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(quantityOrdered, forKey: "quantity")
        aCoder.encode(menuImage, forKey: "menuImage")
        aCoder.encode(restaurantId, forKey: "restaurantId")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "menuItemId")
        let itemName = aDecoder.decodeObject(forKey: "itemName") as! String
        let itemShortDescription = aDecoder.decodeObject(forKey: "itemShortDescription") as! String
        let price = aDecoder.decodeDouble(forKey: "price")
        let quantityOrdered = aDecoder.decodeInteger(forKey: "quantity")
        let menuImage = aDecoder.decodeObject(forKey: "menuImage") as! String
        let restaurantId = aDecoder.decodeInteger(forKey: "restaurantId")
        self.init(id : id, itemName : itemName, itemShortDescription : itemShortDescription, price : price, quantity : quantityOrdered, menuImage : menuImage, restaurantId:restaurantId)
        
    }
}
