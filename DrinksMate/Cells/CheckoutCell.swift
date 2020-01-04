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
import SWXMLHash

class CheckoutCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var promoTxt: UITextField!
    @IBOutlet weak var commentsTxt: UITextView!
    @IBOutlet weak var termsSelect: UISwitch!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    
    var selectedAddress : UserAddress!
    var checkoutVC : CheckOutVC!
    var tableView : UITableView!

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
            
            let url = URL(string: AppUtil.serverURL + "checkout/updateorder")
            
            let orderId = Date().timeIntervalSince1970
            var orderedItems = [] as! [[String : Any]]
            
            for item in AppUtil.cartsList {
                let orderedItem = ["menuitemId" : item.menuitemId!, "quantity": item.cartsNumber!]
                orderedItems.append(orderedItem)
            }
            
            var comments = ""
            if (self.commentsTxt.text.count > 0) {
                comments = self.commentsTxt.text!
            }
            
            let tax = self.jsonToString(json: ["amount":1.5495,"name":"GST"])
            
            let params = ["comments": comments, "deliveryAddressId":self.selectedAddress.addressId!, "entryId":0, "orderId": AppUtil.orderId!, "orderTotal": self.checkoutVC.totalBudget!, "orderedItems": orderedItems, "taxBreakdown":tax!] as [String : Any]
            let headers = AppUtil.user.getAuthentification()
            
            HUD.show(.progress)
            Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
                
//                guard response.result.isSuccess else {
//
//                    return
//                }
                
                self.loadPaymark(orderId: AppUtil.orderId, totalBudget: self.checkoutVC.totalBudget!)
            }
        }
        else {
            self.selectAddress()
            self.paymentBtn.setTitle("MAKE PAYMENT", for: .normal)
        }
    }
    
    func jsonToString(json: [String : Any]) -> String! {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString
        } catch let myJSONError {
            return ""
        }

    }
    
    func loadPaymark(orderId : String, totalBudget: Double) {
        let returnUrl = "http://107.150.52.222:8088/payment/completepaymark?orderId=\(orderId)&applicationConfigurationId=\(AppUtil.config["configurationId"]!)"
        let url = URL(string: "https://demo.paymarkclick.co.nz/api/webpayments/paymentservice/rest/WPRequest")!
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = ["username": 103969, "password": "OBh3C03ijPzBCm2a", "account_id": 625352, "cmd": "_xclick", "amount": totalBudget, "return_url": returnUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!] as [String : Any]
                
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseString { response in
            
            HUD.hide()
            guard response.result.isSuccess else {

                return
            }

            let urlStr = SWXMLHash.parse(response.result.value!)
            let vc = self.checkoutVC.storyboard?.instantiateViewController(withIdentifier: "PayMarkVC") as! PayMarkVC
            vc.urlStr = urlStr["string"].element!.text
            self.checkoutVC.present(vc, animated: false, completion: nil)
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
