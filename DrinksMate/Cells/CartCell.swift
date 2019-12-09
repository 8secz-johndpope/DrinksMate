//
//  CartCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/29/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var menuItem : MenuItem!
    var tableView : UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMenuItemCell (item : MenuItem) {
        self.menuItem = item

        titleLbl.text = item.menuitemName!
        
        let menuitemPrice = self.menuItem.menuitemPrice! * Double(self.menuItem.cartsNumber!)
        priceLbl.text = "$\(menuitemPrice)"
        
        numberLbl.text = "\(self.menuItem.cartsNumber!)"
        
    }
    
    @IBAction func removeAction(_ sender: Any) {
        if (self.menuItem.cartsNumber == 1) {
            AppUtil.cartsList = AppUtil.cartsList.filter() {$0 !== self.menuItem}
            self.tableView.reloadData()
        }
        
        self.self.menuItem.cartsNumber = self.self.menuItem.cartsNumber - 1
        self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
        
        let menuitemPrice = self.menuItem.menuitemPrice! * Double(self.menuItem.cartsNumber!)
        
        priceLbl.text = "$\(menuitemPrice)"
    }
    
    @IBAction func addAction(_ sender: Any) {
        self.menuItem.cartsNumber = self.menuItem.cartsNumber + 1
        self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
        let menuitemPrice = self.menuItem.menuitemPrice! * Double(self.menuItem.cartsNumber!)
        
        priceLbl.text = "$\(menuitemPrice)"
    }

}
