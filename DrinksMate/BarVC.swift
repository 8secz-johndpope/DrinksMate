//
//  BarVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/7/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import PKHUD
import NotificationBannerSwift

class BarVC: ButtonBarPagerTabStripViewController {

    var menuCategories : [MenuCategory]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // ButtonBar Type
        self.buttonBarView.selectedBar.backgroundColor = UIColor.systemBlue
        self.settings.style.selectedBarHeight = 2
        self.settings.style.buttonBarItemBackgroundColor = UIColor.white
        self.settings.style.buttonBarItemTitleColor = UIColor.systemBlue
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
    }
    

    func loadMenuCategory() {
        let user = AppUtil.user.userEmail!
        let password = AppUtil.user.userHashPassword!
        let credentialData = "\(user)===6:\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let url = URL(string: AppUtil.serverURL + "menu/categories")

        HUD.show(.progress)
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Loading Failed!")
                return
            }

            let value = response.result.value as! [[String: Any]]
            
            self.menuCategories = []
            for category in value {
                let menuCategory = MenuCategory()
                menuCategory.setMenuCategory(category: category)
                
                self.menuCategories.append(menuCategory)
            }
            
        }
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func showErrorMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .danger)
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
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        
        
        var vcArray : [CategoryVC]! = []
        
        for category in AppUtil.categories {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
            vc.category = category
            vcArray.append(vc)
        }
        
        return vcArray
    }

}
