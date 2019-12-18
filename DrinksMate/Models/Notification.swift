//
//  Notification.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/9/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class Notification: NSObject {
    
    var notificationBody : String!
    var notificationTitle : String!
    var notificationExpiryDate : [String : Int]!
    var notificationSendDate : [String : Int]!
    
    public init(notification : [String : Any]) {
        self.notificationBody = notification["notificationBody"] as? String
        self.notificationTitle = notification["notificationTitle"] as? String
        
        self.notificationExpiryDate = notification["notificationExpiryDate"] as? [String : Int]
        self.notificationSendDate = notification["notificationSendDate"] as? [String : Int]
    }
    
}
