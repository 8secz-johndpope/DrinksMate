//
//  MenuVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/9/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    var homeVC : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func aboutUsAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        vc.modalPresentationStyle = .fullScreen
        vc.isPolicy = 3
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func accountAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        self.homeVC.tabBarController?.selectedIndex = 2
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cartAction(_ sender: Any) {
        self.homeVC.tabBarController?.selectedIndex = 3
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func contactUsAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        AppUtil.user = DrinkUser()
        UserDefaults.standard.removeObject(forKey: "user_login")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_password")
        
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
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
