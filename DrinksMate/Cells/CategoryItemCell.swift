//
//  CategoryItemCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class CategoryItemCell: UITableViewCell {
    
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var numberLbl: UILabel!

    var menuItem : MenuItem!
    var barVC : BarVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func checkCarts() {
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
        
        if (self.barVC != nil) {
            self.barVC.showCartBadge()
        }
    }
    
    @IBAction func removeAction(_ sender: Any) {
        if (self.menuItem.cartsNumber == 1) {
            self.cartView.isHidden = true
            
            AppUtil.cartsList = AppUtil.cartsList.filter() {$0 !== self.menuItem}
            
            if (self.barVC != nil) {
                self.barVC.showCartBadge()
            }
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
