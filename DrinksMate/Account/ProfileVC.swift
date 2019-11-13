//
//  ProfileVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/11/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import NotificationBannerSwift
import PKHUD

class ProfileVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var billTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (AppUtil.user != nil) {
            self.nameTxt.text = AppUtil.user.userName
            self.phoneTxt.text = AppUtil.user.userPhonenumber
            
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Profile"
    }
    
    @IBAction func saveProfileAction(_ sender: Any) {
        if (self.phoneTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a phone number!")
            return
        }
        
        if (self.phoneTxt.text!.count > 15) {
            self.showErrorMessage(message: "Phone number too long!")
            return
        }
        
        let url = URL(string: AppUtil.serverURL + "auth/update")
        let params : Parameters = ["clientId": 6, "userEmail":AppUtil.user.userEmail!, "userHashPassword": AppUtil.user.userHashPassword!, "userName": self.nameTxt.text!, "userPhonenumber": self.phoneTxt.text!, "userId":0,"userLoyaltyPoints":0,"userReferral":0]

        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Server connection failed.")
                return
            }

            let value = response.result.value as! [String: Any]
            let status = value["userEmail"] as! String
            
            if (status == "_email_not_unique_") {
                self.showErrorMessage(message: "Email already registered!")
            }
            else {
                AppUtil.user = DrinkUser()
                AppUtil.user.setDrinkUser(user: value)
            }

        }
    }
    
    func showErrorMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .danger)
        banner.duration = 1
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
