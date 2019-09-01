//
//  ErrorResponse.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/26/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class ErrorResponse: Codable {
    var error: String
    var message: String
    var status: Int
}
