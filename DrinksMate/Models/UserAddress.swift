//
//  UserAddress.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/2/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class UserAddress: NSObject {
    
    var address : String!
    var clientId : Int!
    var latitude : Double!
    var longitude : Double!
    var userId : Int!
    var isDefault : Bool!
    var addressId : Int!
    var addressCity : String!
    var addressPin : String!
    var addressState : String!
    
    public init(address : [String : Any]) {
        self.address = address["address"] as? String
        self.addressId = address["addressId"] as? Int
        self.addressPin = address["addressPin"] as? String
        self.addressCity = address["addressCity"] as? String
        self.addressState = address["addressState"] as? String
        self.latitude = address["latitude"] as? Double
        self.longitude = address["longitude"] as? Double
        self.isDefault = address["isDefault"] as? Bool
        
    }

}
