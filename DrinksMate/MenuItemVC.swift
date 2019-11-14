//
//  MenuItemVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/14/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import SDWebImage

class MenuItemVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var menuItem : MenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (self.menuItem != nil) {
            
            self.nameLbl.text = self.menuItem.menuitemName
            self.photoImg.sd_setImage(with: URL(string: self.menuItem.menuitemPhoto!), placeholderImage: UIImage(named: "beer_full.png"))
            self.priceLbl.text = "$\(self.menuItem.menuitemPrice!)"
            self.infoLbl.text = self.menuItem.menuitemInfo
        }
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func goCartAction(_ sender: Any) {
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
