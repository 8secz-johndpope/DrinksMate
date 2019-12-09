//
//  AccountMenuVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/11/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class AccountMenuVC: UIViewController {

    var accountVC : AccountVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goProfileAction(_ sender: Any) {
        self.accountVC.moveToViewController(at: 0)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func goResetPasswordAction(_ sender: Any) {
        self.accountVC.moveToViewController(at: 3)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func goAddressesAction(_ sender: Any) {
        self.accountVC.moveToViewController(at: 2)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func goOrdersAction(_ sender: Any) {
        self.accountVC.moveToViewController(at: 1)
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
