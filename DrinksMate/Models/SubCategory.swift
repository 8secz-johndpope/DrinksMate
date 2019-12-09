//
//  SubCategory.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/23/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class SubCategory: NSObject {
    
    var parentCategoryId : Int!
    var subcategoryName : String!
    var menuItems : [MenuItem]!
    
    func setSubCategory(sub : [String : Any]) {
        self.parentCategoryId = sub["parentCategoryId"] as? Int
        self.subcategoryName = sub["subcategoryName"] as? String
        
        self.menuItems = []
        
        let menuItems = sub["menuItems"] as? [[String : Any]]
        for item in menuItems! {
            let menuItem = MenuItem()
            menuItem.setMenuItem(item: item)
            
            self.menuItems.append(menuItem)
        }
    }

}
