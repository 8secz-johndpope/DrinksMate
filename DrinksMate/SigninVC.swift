//
//  SigninVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import CryptoSwift
import NotificationBannerSwift

class SigninVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signinAction(_ sender: Any) {
        if (self.emailTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input an email address!")
            return
        }
        
        if (self.passTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a password!")
            return
        }
        
        let hashData = self.passTxt.text!.data(using: .utf8)?.sha1()
        let hashPass = hashData?.base64EncodedString()
        
        let url = URL(string: AppUtil.serverURL + "auth/login")
//        let params : Parameters = ["clientId": 6, "userEmail":self.emailTxt.text!, "userHashPassword": hashPass!]
        let params : Parameters = ["clientId": 6, "userEmail":self.emailTxt.text!, "userHashPassword": self.passTxt.text!]

        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Login Error!")
                return
            }

            let value = response.result.value as! [String: Any]
            let status = value["userHashPassword"] as! String
            
            if (status == "_invalid_password_") {
                self.showErrorMessage(message: "Invalid Password!")
            }
            else {
                AppUtil.user = DrinkUser()
                AppUtil.user.setDrinkUser(user: value)
                
                UserDefaults.standard.setValue(true, forKey: "user_login")
                UserDefaults.standard.setValue(AppUtil.user.userEmail, forKey: "user_email")
                UserDefaults.standard.setValue(AppUtil.user.userHashPassword, forKey: "user_password")
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    func showErrorMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .danger)
        banner.duration = 1
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
    }
    

    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func goPasswordAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
//    func sha256(_ data: Data) -> Data? {
//        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
//        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
//        return res as Data
//    }
//
//    func sha256(_ str: String) -> String? {
//        guard
//            let data = str.data(using: String.Encoding.utf8),
//            let shaData = sha256(data)
//            else { return nil }
//        let rc = shaData.base64EncodedString(options: [])
//        return rc
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
