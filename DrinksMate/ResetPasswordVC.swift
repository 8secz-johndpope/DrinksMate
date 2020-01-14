//
//  ResetPasswordVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/7/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import CryptoSwift
import NotificationBannerSwift

class ResetPasswordVC: UIViewController{

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var passNewTxt: UITextField!
    
    public var emailStr : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTxt.text = self.emailStr
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        if (self.emailTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input an email address!")
            return
        }
        
        if (self.emailTxt.text!.count > 50) {
            self.showErrorMessage(message: "Email too long!")
            return
        }
        
        if (!self.isValidEmail(emailStr: self.emailTxt.text!)) {
            self.showErrorMessage(message: "Email invalid!")
            return
        }
        
        if (self.passTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a password!")
            return
        }
        
        if (self.passTxt.text!.count < 6) {
            self.showErrorMessage(message: "Password too short!")
            return
        }
        
        if (self.passTxt.text!.count > 100) {
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
        
        if (self.passNewTxt.text != self.passTxt.text) {
            self.showErrorMessage(message: "Password doesn't match!")
            return
        }
    
        let hashData = self.passTxt.text!.data(using: .utf8)?.sha1()
        let newhashPass = hashData?.base64EncodedString()
        
        let url = URL(string: AppUtil.serverURL + "auth/resetpasswordwhileloggedout")
        //let params : Parameters = ["clientId": 6, "userEmail":self.emailTxt.text!, "newHashPassword": newhashPass!]
        let params : Parameters = ["clientId": 6, "userEmail":self.emailTxt.text!, "newHashPassword": self.passNewTxt.text!]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            
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
                AppUtil.user = DrinkUser()
                AppUtil.user.userHashPassword = status
                UserDefaults.standard.setValue(AppUtil.user.userHashPassword, forKey: "user_password")
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func showErrorMessage(message: String) {
        PKHUD.sharedHUD.contentView = PKHUDErrorView(title: nil, subtitle: message)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2)
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
