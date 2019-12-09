//
//  DrinkUser.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/30/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class DrinkUser: NSObject {
    
    var userEmail : String!
    var userHashPassword : String!
    var userId : Int!
    var clientId : Int!
    var userName : String!
    var userPhonenumber : String!
    
    func setDrinkUser (user : [String : Any]) {
        
        self.userEmail = user["userEmail"] as? String
        self.userHashPassword = user["userHashPassword"] as? String
        self.userName = user["userName"] as? String
        self.userPhonenumber = user["userPhonenumber"] as? String
        self.userId = user["userId"] as? Int
    }
    
    func getAuthentification() -> [String : String] {
        let user = AppUtil.user.userEmail!
        let password = AppUtil.user.userHashPassword!
        let credentialData = "\(user)===6:\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        return headers
    }

}
