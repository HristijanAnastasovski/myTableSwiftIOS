//
//  CustomerUser.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/28/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class CustomerUser: NSObject, Codable, NSCoding {
    var id : Int
    var firstName : String
    var lastName : String
    var email : String
    
    
    init(id : Int, firstName : String, lastName : String, email : String){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "customerId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "customerEmail")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "customerId")
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let email = aDecoder.decodeObject(forKey: "customerEmail") as! String
        
        self.init(id : id, firstName : firstName, lastName : lastName, email : email)
        
    }
}
