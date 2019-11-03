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

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendOTPAction(_ sender: Any) {
        
        
        let url = URL(string: AppUtil.serverURL + "auth/otp")
        let params : Parameters = ["clientId": 6, "userEmail":self.emailTxt.text!]
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                    
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Server connection failed.")
                return
            }

            AppUtil.otp = response.result.value             
        }
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
