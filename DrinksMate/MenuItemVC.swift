//
//  MenuItemVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/14/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import PKHUD
import NotificationBannerSwift

class MenuItemVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var cartsBtn: UIButton!
    @IBOutlet weak var cartsView: UIView!
    @IBOutlet weak var numberLbl: UILabel!
    
    var menuItem : MenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (self.menuItem != nil) {
            
            self.nameLbl.text = self.menuItem.menuitemName
            self.photoImg.sd_setImage(with: URL(string: self.menuItem.menuitemPhoto!), placeholderImage: UIImage(named: "beer_full.png"))
            self.priceLbl.text = "$\(self.menuItem.menuitemPrice!)"
            self.infoLbl.text = self.menuItem.menuitemInfo
            
            if (self.menuItem.cartsNumber > 0) {
                self.cartsView.isHidden = false
                self.cartsBtn.isHidden = true
                self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
            }
        }
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }

    
    @IBAction func goWishlistAction(_ sender: Any) {
        let user = AppUtil.user.userEmail!
        let password = AppUtil.user.userHashPassword!
        let credentialData = "\(user)===6:\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let url = URL(string: AppUtil.serverURL + "wishlist/add")
        let params = ["clientId": 6, "menuitemId": self.menuItem.menuitemId!, "userId": AppUtil.user.userId!]
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Loading Failed!")
                return
            }
            
            self.wishlistBtn.isHidden = true
            self.showMessage(message: "Added to wishlist!")
        }
    }
    
    @IBAction func goCartAction(_ sender: Any) {
        self.cartsView.isHidden = false
        
        self.menuItem.cartsNumber = 1
        AppUtil.cartsList.append(self.menuItem)

    }
    
    @IBAction func removeAction(_ sender: Any) {
        if (self.menuItem.cartsNumber == 1) {
            self.cartsView.isHidden = true
            self.cartsBtn.isHidden = false
            AppUtil.cartsList = AppUtil.cartsList.filter() {$0 !== self.menuItem}
            
            return
        }
        
        self.self.menuItem.cartsNumber = self.self.menuItem.cartsNumber - 1
        self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
    }
    
    @IBAction func addAction(_ sender: Any) {
        self.menuItem.cartsNumber = self.menuItem.cartsNumber + 1
        self.numberLbl.text = "\(self.menuItem.cartsNumber!)"
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
