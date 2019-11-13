//
//  MenuVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/9/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    var homeVC : HomeVC!

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
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: false, completion: nil)
        self.homeVC.tabBarController?.selectedIndex = 1
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func menuAction(_ sender: Any) {
    
    }
    
    @IBAction func cartAction(_ sender: Any) {
    }
    
    @IBAction func contactUsAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        vc.modalPresentationStyle = .fullScreen
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

}
