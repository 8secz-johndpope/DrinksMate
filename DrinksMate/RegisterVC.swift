//
//  RegisterVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class RegisterVC: UIViewController {
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var phonenumberTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    
    @IBOutlet weak var acceptSwitch: UISwitch!
    @IBOutlet weak var termsBtn: UIButton!
    
    @IBOutlet weak var policyBtn: UIButton!
    
    var birthdayDate : Date!
    let yourAttributes: [NSAttributedString.Key: Any] = [
                                                            .font: UIFont.systemFont(ofSize: 15),
                                                            .foregroundColor: UIColor.blue,
                                                            .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var attributeString = NSMutableAttributedString(string: "Terms and Conditions",
                                                        attributes: yourAttributes)
        self.termsBtn.setAttributedTitle(attributeString, for: .normal)
        
        attributeString = NSMutableAttributedString(string: "Privacy Policy",
        attributes: yourAttributes)
        self.policyBtn.setAttributedTitle(attributeString, for: .normal)
    }
    
    @IBAction func textFieldEditing(_ sender: Any) {
        let datePickerView:UIDatePicker = UIDatePicker()
         
        datePickerView.datePickerMode = UIDatePicker.Mode.date
         
        (sender as! UITextField).inputView = datePickerView
         
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
         
        let dateFormatter = DateFormatter()
         
        dateFormatter.dateStyle = .medium
         
        dateFormatter.timeStyle = .none
         
        self.dateTxt.text = dateFormatter.string(from: sender.date)
        self.birthdayDate = sender.date
    }
    
    @IBAction func goTermsAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        vc.modalPresentationStyle = .fullScreen
        vc.isPolicy = 0
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func goPolicyAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        vc.modalPresentationStyle = .fullScreen
        vc.isPolicy = 1
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        if (self.fullnameTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a full name!")
            return
        }
        
        if (self.fullnameTxt.text!.count > 100) {
            self.showErrorMessage(message: "Name too long!")
            return
        }
        
        if (self.phonenumberTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a phone number!")
            return
        }
        
        if (self.phonenumberTxt.text!.count > 15) {
            self.showErrorMessage(message: "Phone number too long!")
            return
        }
        
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
        
        if (self.passwordTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a password!")
            return
        }
        
        if (self.passwordTxt.text!.count < 6) {
            self.showErrorMessage(message: "Password too short!")
            return
        }
        
        if (self.passwordTxt.text!.count > 100) {
            self.showErrorMessage(message: "Password too long!")
            return
        }
        
        if (self.dateTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a birthday!")
            return
        }
        
        let diffYears = Calendar.current.dateComponents([.year], from: self.birthdayDate, to: Date()).year
        if (diffYears! < 18) {
            self.showErrorMessage(message: "Age cannot be less than 18!")
            return
        }
        
        if (!self.acceptSwitch.isOn) {
            self.showErrorMessage(message: "You must agree terms and conditions!")
            return
        }
        
        let hashPass = self.passwordTxt.text?.sha1()
        
        let url = URL(string: AppUtil.serverURL + "auth/register")
        let params : Parameters = ["clientId": 6, "userEmail":self.emailTxt.text!, "userHashPassword": hashPass!, "userName": self.fullnameTxt.text!, "userPhonenumber": self.phonenumberTxt.text!, "userId":0,"userLoyaltyPoints":0,"userReferral":0]

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
