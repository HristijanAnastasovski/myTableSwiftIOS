//
//  Order.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/28/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class Order: Codable {
    var id: Int
    var customer: CustomerUser
    var restaurant: RestaurantUser
    var numberOfSeats: Int
    var dateTime: String
}

