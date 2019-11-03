//
//  FirstVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var ageView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func yesAction(_ sender: Any) {
        self.backView.isHidden = true
        self.ageView.isHidden = true
    }
    
    @IBAction func noAction(_ sender: Any) {
        exit(0)
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
        let vc = self.storyboard?.instantiateViewController(identifier: "SigninVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
    
    @IBAction func goRegisterAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RegisterVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
    
}
