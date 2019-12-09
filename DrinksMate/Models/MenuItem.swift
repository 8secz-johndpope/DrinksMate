//
//  MenuItem.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/12/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class MenuItem: NSObject {

    var wishlistId : Int!
    var menuitemId : Int!
    var menuitemCategory : Int!
    var menuitemDescription : String!
    var menuitemInfo : String!
    var menuitemName : String!
    var menuitemPhoto : String!
    var menuitemPrice : Double!
    var menuitemPurchasePrice : Double!
    var quantityRemaining : Int!
    var cartsNumber : Int!
    
    func setMenuItem(item : [String : Any]) {
        
        self.menuitemId = item["menuitemId"] as? Int
        
        if (item["wishlistId"] != nil) {
            self.wishlistId = item["wishlistId"] as? Int
            
            for category in AppUtil.categories {
                if category.subCategories.count > 0 {
                    
                    for sub in category.subCategories {
                        
                        if let foundedItem = sub.menuItems.first(where: {$0.menuitemId == self.menuitemId}) {
                            self.menuitemCategory = foundedItem.menuitemCategory
                            self.menuitemPrice = foundedItem.menuitemPrice
                            self.quantityRemaining = foundedItem.quantityRemaining
                            
                            self.menuitemDescription = foundedItem.menuitemDescription
                            self.menuitemInfo = foundedItem.menuitemInfo
                            self.menuitemName = foundedItem.menuitemName
                            self.menuitemPhoto = foundedItem.menuitemPhoto
                            self.menuitemPurchasePrice = foundedItem.menuitemPurchasePrice
                        }
                    }
                }
                else {
                    if let foundedItem = category.menuItems.first(where: {$0.menuitemId == self.menuitemId}) {
                        self.menuitemCategory = foundedItem.menuitemCategory
                        self.menuitemPrice = foundedItem.menuitemPrice
                        self.quantityRemaining = foundedItem.quantityRemaining
                        
                        self.menuitemDescription = foundedItem.menuitemDescription
                        self.menuitemInfo = foundedItem.menuitemInfo
                        self.menuitemName = foundedItem.menuitemName
                        self.menuitemPhoto = foundedItem.menuitemPhoto
                        self.menuitemPurchasePrice = foundedItem.menuitemPurchasePrice
                    }
                }
            }
        }
        else {
            self.menuitemCategory = item["menuitemCategory"] as? Int
            self.menuitemPrice = item["menuitemPrice"] as? Double
            self.quantityRemaining = item["quantityRemaining"] as? Int
            
            self.menuitemDescription = item["menuitemDescription"] as? String
            self.menuitemInfo = item["menuitemInfo"] as? String
            self.menuitemName = item["menuitemName"] as? String
            self.menuitemPhoto = item["menuitemPhoto"] as? String
            self.menuitemPurchasePrice = item["menuitemPurchasePrice"] as? Double
        }
        
        self.cartsNumber = 0
    }
}
