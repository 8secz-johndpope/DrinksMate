//
//  TaxConfig.swift
//  DrinksMate
//
//  Created by LeemingJin on 1/22/20.
//  Copyright © 2020 LeemingJin. All rights reserved.
//

import UIKit

class TaxConfig: NSObject {
    
    var isPercent : Int!
    var taxAmount : Double!
    var taxName : String!
    
    public init(tax : [String : Any]) {
        self.isPercent = tax["isPercent"] as? Int
        self.taxAmount = tax["taxAmount"] as? Double
        self.taxName   = tax["taxName"] as? String
    }
}
