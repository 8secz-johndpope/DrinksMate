//
//  PayConfig.swift
//  DrinksMate
//
//  Created by LeemingJin on 1/23/20.
//  Copyright © 2020 LeemingJin. All rights reserved.
//

import UIKit

class PayConfig: NSObject {
    
    var accountId : Int!
    var applicationConfigurationId : Int!
    var clientId : Int!
    var username : String!
    var password : String!
    
    public init(payConfig : [String : Any]) {
        
        self.accountId = payConfig["accountId"] as? Int
        self.applicationConfigurationId = payConfig["applicationConfigurationId"] as? Int
        self.clientId = payConfig["clientId"] as? Int
        self.username = payConfig["username"] as? String
        self.password = payConfig["password"] as? String
    }

}
