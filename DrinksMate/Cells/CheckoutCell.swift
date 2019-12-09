//
//  CheckoutCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/3/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class CheckoutCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var promoTxt: UITextField!
    @IBOutlet weak var commentsTxt: UITextView!
    @IBOutlet weak var termsSelect: UISwitch!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    
    var selectedAddress : UserAddress!
    var checkoutVC : CheckOutVC!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.commentsTxt.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comments / Instructions, if any" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comments / Instructions, if any"
            textView.textColor = UIColor.lightGray
        }
    }

    @IBAction func promoApplyAction(_ sender: Any) {
    }
    
    @IBAction func chooseDifferentLocationAction(_ sender: Any) {
        self.selectAddress()
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
        if (self.selectedAddress != nil) {
            
        }
        else {
            self.selectAddress()
            self.paymentBtn.setTitle("MAKE PAYMENT", for: .normal)
        }
    }
    
    func selectAddress() {
        let addressDialog = UIAlertController(title: "Select Delivery Address", message: nil, preferredStyle: .alert)
        
        for address in AppUtil.addressList {
            
            let addressAction = UIAlertAction(title: address.address, style: .default) { (action) in
                
                self.addressView.isHidden = false
                self.selectedAddress = address
                self.addressLbl.text = address.address
            }
            
            addressDialog.addAction(addressAction)
        }
        
        let anotherAction = UIAlertAction(title: "New Address", style: .default) { (action) in
            let vc = self.checkoutVC.storyboard?.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
            self.checkoutVC.present(vc, animated: false, completion: nil)
        }
        
        addressDialog.addAction(anotherAction)
        
        self.checkoutVC.present(addressDialog, animated: true, completion: nil)
    }
    
}
