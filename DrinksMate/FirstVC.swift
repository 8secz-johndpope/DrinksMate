//
//  FirstVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class FirstVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: AppUtil.serverURL + "features/6")
        
        // Config api
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
                    
            guard response.result.isSuccess else {
                return
            }

            AppUtil.config = response.result.value as? [String: Any]
            self.showMessage(msg: "Configuration Up To Date!")
        }
    }
    
    @IBAction func yesAction(_ sender: Any) {
        self.backView.isHidden = true
        self.ageView.isHidden = true
    }
    
    @IBAction func noAction(_ sender: Any) {
        self.backView.isHidden = true
        self.ageView.isHidden = true
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        vc.modalPresentationStyle = .popover
        vc.isPolicy = 2
        self.present(vc, animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goSigninAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
    
    @IBAction func goRegisterAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
    
    func showMessage(msg: String) {
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: msg)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
            // Completion Handler
            self.signinBtn.isHidden = false
            self.registerBtn.isHidden = false
            self.backView.isHidden = false
            self.ageView.isHidden = false
        }
    }
    
}
