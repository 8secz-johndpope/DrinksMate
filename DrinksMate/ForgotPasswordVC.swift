//
//  ForgotPasswordVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import NotificationBannerSwift

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var otpTxt: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var resendBtn: UIButton!
    
    var isSentOTP : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.isSentOTP = false
    }
    
    @IBAction func sendOTPAction(_ sender: Any) {
        if (isSentOTP) {
            if (AppUtil.otp.contains(self.otpTxt.text!)) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                vc.emailStr = self.emailTxt.text!
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
                
                return
            }
            else {
                self.showErrorMessage(message: "OTP doesn't match!")
                
                return
            }
        }
        
        let url = URL(string: AppUtil.serverURL + "auth/otp")
        let params : Parameters = ["clientId": 6, "userEmail":self.emailTxt.text!]
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                    
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "OTP Error!")
                return
            }

            let otp = response.result.value
            
            if ((otp?.contains("_email_not_found_"))! ) {
                self.showErrorMessage(message: "Email not found!")
            }
            else {
                AppUtil.otp = otp
                
                self.showMessage(msg: "OTP sent. Please check email!")
                self.isSentOTP = true
                self.otpTxt.isHidden = false
                self.resendBtn.isHidden = false
                self.sendBtn.setTitle("VERIFY OTP", for: .normal)
            }
        }
    }
    
    @IBAction func resendOTPAction(_ sender: Any) {
        let url = URL(string: AppUtil.serverURL + "auth/otp")
        let params : Parameters = ["clientId": 6, "userEmail":self.emailTxt.text!]
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                    
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "OTP Error!")
                return
            }

            let otp = response.result.value
            
            if (otp == "_email_not_found_") {
                self.showErrorMessage(message: "Email not found!")
            }
            else {
                self.showMessage(msg: "OTP resent.")
            }
        }
    }
    
    func showErrorMessage(message: String) {

        let banner = NotificationBanner(title: nil, subtitle: message, style: .danger)
        banner.duration = 1
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
        
    }
    
    func showMessage(msg: String) {
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: msg)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
            // Completion Handler
            
        }
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
