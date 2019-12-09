//
//  Order.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/8/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class Order: NSObject {
    
    var orderId : Int!
    var orderStatus : String!
    var orderType : String!
    var orderTotal : Double!
    var deliveryAddressId : Int!
    var comments : String!
    var paymentResponse : Payment!
    var paymentStatus : String!
    var paymentType : String!
    var orderedItems : [MenuItem]!
    
    public init(order : [String : Any]) {
        
        self.orderId = order["orderId"] as? Int
        self.orderStatus = order["orderStatus"] as? String
        self.orderType = order["orderType"] as? String
        self.comments = order["comments"] as? String
        self.orderTotal = order["orderTotal"] as? Double
        self.paymentStatus = order["paymentStatus"] as? String
        self.paymentType = order["paymentType"] as? String
        
        let items = order["orderedItems"] as! [[String : Any]]
        self.orderedItems = []
        
        for item in items {
            let menuItem = MenuItem()
            menuItem.setMenuItem(item: item)
            self.orderedItems.append(menuItem)
        }
        
        let paymentResponse = order["paymentResponse"] as? String
        let jsonResponse = paymentResponse?.data(using: .utf8)
        do {
            
            let json = try JSONSerialization.jsonObject(with: jsonResponse!, options: .allowFragments) as? [String : Any]
            self.paymentResponse = Payment(payment: json!)
        } catch let error as NSError {
            print (error)
        }
        
        
    }

}
