//
//  ResetPassVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/11/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import PKHUD
import NotificationBannerSwift
import Alamofire

class ResetPassVC: UIViewController, IndicatorInfoProvider  {

    @IBOutlet weak var passOldTxt: UITextField!
    @IBOutlet weak var passNewTxt: UITextField!
    @IBOutlet weak var passNewAgainTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Reset Password"
    }

    @IBAction func resetPasswordAction(_ sender: Any) {
        if (self.passOldTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a password!")
            return
        }
        
        if (self.passOldTxt.text!.count < 6) {
            self.showErrorMessage(message: "Password too short!")
            return
        }
        
        if (self.passOldTxt.text!.count > 20) {
            self.showErrorMessage(message: "Password too long!")
            return
        }
        
        if (self.passNewTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a password!")
            return
        }
        
        if (self.passNewTxt.text!.count < 6) {
            self.showErrorMessage(message: "Password too short!")
            return
        }
        
        if (self.passNewTxt.text!.count > 100) {
            self.showErrorMessage(message: "Password too long!")
            return
        }
        
        if (self.passNewAgainTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a password!")
            return
        }
        
        if (self.passNewAgainTxt.text!.count < 6) {
            self.showErrorMessage(message: "Password too short!")
            return
        }
        
        if (self.passNewAgainTxt.text!.count > 100) {
            self.showErrorMessage(message: "Password too long!")
            return
        }
        
        if (self.passNewTxt.text != self.passNewAgainTxt.text) {
            self.showErrorMessage(message: "Password doesn't match!")
            return
        }

        let headers = AppUtil.user.getAuthentification()
        
        let oldhashData = self.passOldTxt.text!.data(using: .utf8)?.sha1()
        let oldhashPass = oldhashData?.base64EncodedString()
        
        let newhashData = self.passNewTxt
            .text!.data(using: .utf8)?.sha1()
        let newhashPass = newhashData?.base64EncodedString()
        
        let url = URL(string: AppUtil.serverURL + "auth/resetpassword")
//        let params : Parameters = ["clientId": 6, "userEmail":AppUtil.user.userEmail!,"oldHashPassword": oldhashPass!, "newHashPassword": newhashPass!]
        let params : Parameters = ["clientId": 6, "userEmail":AppUtil.user.userEmail!,"oldHashPassword": self.passOldTxt.text!, "newHashPassword": self.passNewTxt.text!]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Please try again!")
                return
            }

            let value = response.result.value as! [String: Any]
            let status = value["userHashPassword"] as! String
            
            if (status == "_old_password_incorrect") {
                self.showErrorMessage(message: "Incorrect Password!")
            }
            else {
                //AppUtil.user = DrinkUser()
                self.passOldTxt.text = ""
                self.passNewTxt.text = ""
                self.passNewAgainTxt.text = ""
                
                AppUtil.user.userHashPassword = status
                UserDefaults.standard.setValue(AppUtil.user.userHashPassword, forKey: "user_password")
                
                self.showMessage(message: "Password Changed!")
            }
        }
    }
    
    func showErrorMessage(message: String) {
        PKHUD.sharedHUD.contentView = PKHUDErrorView(title: nil, subtitle: message)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2)
    }
    
    func showMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .success)
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
