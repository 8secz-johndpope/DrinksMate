//
//  PayCard.swift
//  DrinksMate
//
//  Created by LeemingJin on 1/22/20.
//  Copyright © 2020 LeemingJin. All rights reserved.
//

import UIKit

class PayCard: NSObject {
    
    var cardExpiry : String!
    var cardHolder : String!
    var cardNumber : String!
    var cardToken : String!
    var cardType : String!
    var cardId : Int!
    var isDefault : Bool!
    var userId : Int!
    
    public init(card : [String : Any]) {
        
        self.cardExpiry = card["cardExpiry"] as? String
        self.cardHolder = card["cardHolder"] as? String
        self.cardNumber = card["cardNumber"] as? String
        self.cardToken = card["cardToken"] as? String
        self.cardType = card["cardType"] as? String
        self.cardId = card["cardId"] as? Int
        self.userId = card["userId"] as? Int
        self.isDefault = card["isDefault"] as? Bool
    }

}
