//
//  MenuCategory.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/12/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class MenuCategory: NSObject {
    
    var categoryName : String!
    var photo : String!
    var menuItems : [MenuItem]!
    
    func setMenuCategory(category : [String : Any]) {
        
        self.categoryName = category["categoryName"] as? String
        self.photo = category["photo"] as? String
        
        self.menuItems = []
        
        let menuItems = category["menuItems"] as? [[String : Any]]
        for item in menuItems! {
            let menuItem = MenuItem()
            menuItem.setMenuItem(item: item)
            
            self.menuItems.append(menuItem)
        }
    }

}
