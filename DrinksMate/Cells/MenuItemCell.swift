//
//  MenuItemCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import SDWebImage

class MenuItemCell: UICollectionViewCell {
   
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var homeVC : HomeVC!
    var menuItem : MenuItem!
    
    func setMenuItemCell (item : MenuItem) {
        self.menuItem = item
        
        photoImg.sd_setImage(with: URL(string: item.menuitemPhoto!), placeholderImage: UIImage(named: "beer_full.png"))
        
        nameLbl.text = item.menuitemName!
        priceLbl.text = "$\(item.menuitemPrice!)"
        
        
        if (self.menuItem.cartsNumber > 0) {
            self.cartView.isHidden = false
            self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
        }
        else {
            self.cartView.isHidden = true
        }
    }
    
    @IBAction func goCartAction(_ sender: Any) {
        self.cartView.isHidden = false
        
        self.menuItem.cartsNumber = 1
        AppUtil.cartsList.append(self.menuItem)
        
        let tabItem = self.homeVC.tabBarController?.tabBar.items
        let cartTab = tabItem![3]
        cartTab.badgeValue = "\(AppUtil.cartsList.count)"
    }
    
    @IBAction func removeAction(_ sender: Any) {
        if (self.menuItem.cartsNumber == 1) {
            self.cartView.isHidden = true
            
            AppUtil.cartsList = AppUtil.cartsList.filter() {$0 !== self.menuItem}
            
            let tabItem = self.homeVC.tabBarController?.tabBar.items
            let cartTab = tabItem![3]
            cartTab.badgeValue = "\(AppUtil.cartsList.count)"
            return
        }
        
        self.self.menuItem.cartsNumber = self.self.menuItem.cartsNumber - 1
        self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
    }
    
    @IBAction func addAction(_ sender: Any) {
        self.menuItem.cartsNumber = self.menuItem.cartsNumber + 1
        self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
    }
}
