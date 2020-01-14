//
//  ContactUsVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/9/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import NotificationBannerSwift
import MessageUI

class ContactUsVC: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var subjectTxt: UITextField!
    @IBOutlet weak var messageTxt: UITextView!
    
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
                                                        .font: UIFont.systemFont(ofSize: 15),
                                                        .foregroundColor: UIColor.blue,
                                                        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if (self.nameTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a full name!")
            return
        }
        
        if (self.nameTxt.text!.count > 100) {
            self.showErrorMessage(message: "Name too long!")
            return
        }
        
        if (self.phoneTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a phone number!")
            return
        }
        
        if (self.phoneTxt.text!.count > 15) {
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
        
        if (self.subjectTxt.text?.count == 0) {
            self.showErrorMessage(message: "Please input a subject!")
            return
        }
        
        if (self.subjectTxt.text!.count > 100) {
            self.showErrorMessage(message: "Subject too long!")
            return
        }
        
        let url = URL(string: AppUtil.serverURL + "misc/contactus")
        let params : Parameters = ["name":self.nameTxt.text!, "phone": self.phoneTxt.text!, "email": self.emailTxt.text!, "subject": self.subjectTxt.text!, "message":self.messageTxt.text!]

        let headers = AppUtil.user.getAuthentification()
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Server connection failed.")
                return
            }

            self.showMessage(message: "Request sent!")
        }
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func showErrorMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .danger)
        banner.duration = 1
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
        
    }
    
    func showMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .success)
        banner.duration = 1
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func phoneCallAction(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "tel://+6493920055")! as URL)
    }
    
    @IBAction func sendEmailAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.setToRecipients(["support@drinksmate.kiwi"])
            composeVC.setSubject("")
            composeVC.setMessageBody("", isHTML: false)

            // Present the view controller modally.
            present(composeVC, animated: true, completion: nil)
        } else {
            // show failure alert
        }
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
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
