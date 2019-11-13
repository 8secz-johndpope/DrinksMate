//
//  MenuItem.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/12/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class MenuItem: NSObject {

    var menuitemId : Int!
    var menuitemCategory : Int!
    var menuitemDescription : String!
    var menuitemInfo : String!
    var menuitemName : String!
    var menuitemPhoto : String!
    var menuitemPrice : Double!
    var quantityRemaining : Int!
    
    func setMenuItem(item : [String : Any]) {
        self.menuitemId = item["menuitemId"] as? Int
        self.menuitemCategory = item["menuitemCategory"] as? Int
        self.menuitemPrice = item["menuitemPrice"] as? Double
        self.quantityRemaining = item["quantityRemaining"] as? Int
        
        self.menuitemDescription = item["menuitemDescription"] as? String
        self.menuitemInfo = item["menuitemInfo"] as? String
        self.menuitemName = item["menuitemName"] as? String
        self.menuitemPhoto = item["menuitemPhoto"] as? String
    }
}
