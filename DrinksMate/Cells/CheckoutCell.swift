//
//  CheckoutCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/3/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Alamofire
import PKHUD

import iOSDropDown

class CheckoutCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var promoTxt: UITextField!
    @IBOutlet weak var commentsTxt: UITextView!
    @IBOutlet weak var termsSelect: UISwitch!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timeSlot: DropDown!
    
    var selectedAddress : UserAddress!
    var checkoutVC : CheckOutVC!
    var tableView : UITableView!
    
    let slots = ["10:00 AM - 11:00 AM", "10:30 AM - 11:30 AM","11:00 AM - 12:00 PM","11:30 AM - 12:30 PM","12:00 PM - 01:00 PM","12:30 PM - 01:30 PM","01:00 PM - 02:00 PM","01:30 PM - 02:30 PM","02:00 PM - 03:00 PM","02:30 PM - 03:30 PM","03:00 PM - 04:00 PM","03:30 PM - 04:30 PM","04:00 PM - 05:00 PM","04:30 PM - 05:30 PM","05:00 PM - 06:00 PM","05:30 PM - 06:30 PM","06:00 PM - 07:00 PM","06:30 PM - 07:30 PM","07:00 PM - 08:00 PM","07:30 PM - 08:30 PM","08:00 PM - 09:00 PM","08:30 PM - 09:30 PM","09:00 PM - 10:00 PM","09:30 PM - 10:00 PM"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.commentsTxt.delegate = self
        self.timeSlot.isSearchEnable = false
        
        self.timeSlot.optionArray = []
        self.timeSlot.optionArray.append("Select Delivery Time Slot")
        
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "hh:mm a"
        let currentTime = timeFormat.string(from: Date())
        
        for slot in slots {
            let startTime = slot.prefix(8)
            
            if (timeFormat.date(from: String(startTime))! > timeFormat.date(from: currentTime)!) {
                self.timeSlot.optionArray.append(slot)
            }
        }
        
        
        self.timeSlot.didSelect { (selectedTxt, index, id) in
            
        }
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
    
    func loadSelectedAddress() {
        self.addressView.isHidden = false
        self.addressLbl.text = self.selectedAddress.address
    }

    @IBAction func promoApplyAction(_ sender: Any) {
    }
    
    @IBAction func chooseDifferentLocationAction(_ sender: Any) {
        self.selectAddress()
    }
    
    @IBAction func termsSelectAction(_ sender: Any) {
        //self.termsSelect.isOn = !self.termsSelect.isOn
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
        if (self.selectedAddress != nil) {
            if (!self.termsSelect.isOn) {
                
                self.showMessage(message: "Please agree Terms and Conditions!")
                return
            }
            
            let vc = self.checkoutVC.storyboard?.instantiateViewController(withIdentifier: "CardVC") as! CardVC
            vc.totalBudget = self.checkoutVC.totalBudget
            vc.params = self.getUpdateOrderParams()
            vc.modalPresentationStyle = .overCurrentContext
            self.checkoutVC.present(vc, animated: false, completion: nil)
        }
        else {
            self.selectAddress()
            self.paymentBtn.setTitle("MAKE PAYMENT", for: .normal)
        }
    }
    
    func jsonToString(json: [String : Any]) -> String! {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            var convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            convertedString = convertedString!.replacingOccurrences(of: "\n", with: "")
            
            return convertedString
        } catch _ {
            return ""
        }

    }
    
    func getUpdateOrderParams() -> [String : Any] {
        var orderedItems = [] as! [[String : Any]]
        
        for item in AppUtil.cartsList {
            let orderedItem = ["menuitemId" : item.menuitemId!, "quantity": item.cartsNumber!]
            orderedItems.append(orderedItem)
        }
        
        var comments = ""
        if (self.commentsTxt.text.count > 0) {
            comments = self.commentsTxt.text!
        }
        
        let tax = self.jsonToString(json: ["amount":AppUtil.tax.taxAmount!, "name": AppUtil.tax.taxName!])
        
        let params = ["comments": comments, "deliveryAddressId":self.selectedAddress.addressId!, "entryId":0, "orderId": AppUtil.orderId!, "orderTotal": self.checkoutVC.totalBudget!, "orderedItems": orderedItems, "taxBreakdown": "[\(tax!)]"] as [String : Any]
        return params
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
            vc.prevVC = self.checkoutVC
            self.checkoutVC.present(vc, animated: false, completion: nil)
        }
        
        addressDialog.addAction(anotherAction)
        
        self.checkoutVC.present(addressDialog, animated: true, completion: nil)
    }
    
    
    func showPaymentDialog() {
        let addressDialog = UIAlertController(title: "Select Payment Transfer", message: nil, preferredStyle: .alert)
                    
        let card = UIAlertAction(title: "Credit Card / Bank Transfer", style: .default) { (action) in

        }
        
        let cod = UIAlertAction(title: "COD", style: .default) { (action) in

        }
        
        addressDialog.addAction(card)
        addressDialog.addAction(cod)
        
        self.checkoutVC.present(addressDialog, animated: true, completion: nil)
    }
    
    func showMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .success)
        banner.duration = 1
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self.checkoutVC)
    }
    
}
