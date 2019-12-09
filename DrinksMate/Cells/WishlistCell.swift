//
//  WishlistCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire

class WishlistCell: UITableViewCell {
    
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var numberLbl: UILabel!
    
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
    
    @IBAction func goCartAction(_ sender: Any) {
        self.cartView.isHidden = false
        
        self.menuItem.cartsNumber = 1
        AppUtil.cartsList.append(self.menuItem)

    }
    
    @IBAction func removeAction(_ sender: Any) {
        if (self.menuItem.cartsNumber == 1) {
            self.cartView.isHidden = true
            
            AppUtil.cartsList = AppUtil.cartsList.filter() {$0 !== self.menuItem}
            
            return
        }
        
        self.self.menuItem.cartsNumber = self.self.menuItem.cartsNumber - 1
        self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
    }
    
    @IBAction func addAction(_ sender: Any) {
        self.menuItem.cartsNumber = self.menuItem.cartsNumber + 1
        self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
    }
    
    @IBAction func removeWishlistAction(_ sender: Any) {
        let user = AppUtil.user.userEmail!
        let password = AppUtil.user.userHashPassword!
        let credentialData = "\(user)===6:\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let url = URL(string: AppUtil.serverURL + "wishlist/delete")
        let params = ["wishlistId": self.menuItem.wishlistId!]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            self.tableView.reloadData()
        }
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

}
