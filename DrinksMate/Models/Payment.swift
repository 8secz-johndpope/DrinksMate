//
//  Payment.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/8/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class Payment: NSObject {
    var transactionId : String!
    var transactionDate : String!
    
    public init(payment : [String : Any]) {
        self.transactionId = payment["transactionId"] as? String
        self.transactionDate = payment["transactionDate"] as? String
    }
}
