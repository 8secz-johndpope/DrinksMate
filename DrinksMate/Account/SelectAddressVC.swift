//
//  SelectAddressVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/26/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class SelectAddressVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func currentLocationAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        vc.isOther = false

        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func otherLocationAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        vc.isOther = true
        self.present(vc, animated: false, completion: nil)
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
