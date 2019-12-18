//
//  AddressCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/2/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire

class AddressCell: UITableViewCell {

    @IBOutlet weak var optionImg: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var addressTxt: UITextView!
    
    
    var userAddress : UserAddress!
    var tableView : UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectAction(_ sender: Any) {
        
        if (!self.userAddress.isDefault) {
            self.optionImg.isHidden = self.userAddress.isDefault
            self.userAddress.isDefault = !self.userAddress.isDefault
            
            self.setDefaultAddress()
        }
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        
        self.deleteAddress()
    }
    
    @IBAction func editAction(_ sender: Any) {
        if (self.addressTxt.isEditable) {
            self.addressTxt.isEditable = false
            
            self.editBtn.setBackgroundImage(UIImage(named: "edit"), for: .normal)
            self.userAddress.address = self.addressTxt.text
            
            self.updateAddress()
        }
        else {
            self.addressTxt.isEditable = true
            self.editBtn.setBackgroundImage(UIImage(named: "save"), for: .normal)
        }
    }
    
    func setDefaultAddress() {
        let url = URL(string: AppUtil.serverURL + "checkout/addressdefault")
        let params = ["addressId": self.userAddress.addressId!]
        let headers = AppUtil.user.getAuthentification()
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            self.tableView.reloadData()
        }
    }
    
    func deleteAddress() {
        let url = URL(string: AppUtil.serverURL + "checkout/deleteaddress")
        let params = ["addressId": self.userAddress.addressId!, "address": self.userAddress.address!] as [String : Any]
        let headers = AppUtil.user.getAuthentification()
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().response { response in
            
            let indexPath = self.tableView.indexPath(for: self)
            AppUtil.addressList.remove(at: indexPath!.row)
            self.tableView.reloadData()
        }
    }
    
    func updateAddress() {
        let url = URL(string: AppUtil.serverURL + "checkout/updateaddress")
        let params = ["addressId": self.userAddress.addressId!, "address": self.userAddress.address!] as [String : Any]
        let headers = AppUtil.user.getAuthentification()
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            self.tableView.reloadData()
        }
    }
    
}
