//
//  HomeVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/4/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import NotificationBannerSwift

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    var menuCategories : [MenuCategory]!
    var menuTopOrders : [MenuItem]!
    var menuPrevOrders : [MenuItem]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AppUtil.categories = []
        AppUtil.cartsList = []
        
        self.menuCategories = []
        self.menuTopOrders = []
        self.menuPrevOrders = []
        
        if (AppUtil.fcmToken != nil) {
            let url = URL(string: AppUtil.serverURL + "notification/firebase_token")
                    let headers = AppUtil.user.getAuthentification()
            let params = ["token" : AppUtil.fcmToken!]
                    
            Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().response { response in
            
                self.loadMenuCategory()
            }
        }
        else {
            self.loadMenuCategory()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (AppUtil.cartsList.count > 0) {
            let tabItem = self.tabBarController?.tabBar.items
            let cartTab = tabItem![3]
            cartTab.badgeValue = "\(AppUtil.cartsList.count)"
        }
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
            AppUtil.categories = []
            
            for category in value {
                let menuCategory = MenuCategory()
                menuCategory.setMenuCategory(category: category)
                
                self.menuCategories.append(menuCategory)
            }
            
            AppUtil.categories = self.menuCategories
            //self.loadPrevOrder()
            self.loadTopOrder()
        }
    }
    
    func loadTopOrder() {
        let user = AppUtil.user.userEmail!
        let password = AppUtil.user.userHashPassword!
        let credentialData = "\(user)===6:\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let url = URL(string: AppUtil.serverURL + "order/top")
        let params = ["offset": 0, "limit":10]
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Loading Failed!")
                return
            }

            let value = response.result.value as! [[String: Any]]
            
            self.menuTopOrders = []
            for item in value {
                let menuItem = MenuItem()
                menuItem.setMenuItem(item: item)
                
                self.menuTopOrders.append(menuItem)
            }
            
            self.loadPrevOrder()
        }
    }
    
    func loadPrevOrder() {
        let user = AppUtil.user.userEmail!
        let password = AppUtil.user.userHashPassword!
        let credentialData = "\(user)===6:\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        let url = URL(string: AppUtil.serverURL + "order/previousitems")
        let params = ["offset": 0, "limit":10]
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Loading Failed!")
                return
            }

            let value = response.result.value as! [[String: Any]]
            
            self.menuPrevOrders = []
            for item in value {
                let menuItem = MenuItem()
                menuItem.setMenuItem(item: item)
                
                self.menuPrevOrders.append(menuItem)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            case 0:
                return 180
            case 1:
                return 60
            case 2:
                var cellHeight : CGFloat = 0.0
                if (self.menuCategories.count % 3 == 0) {
                    cellHeight = 160 * CGFloat(self.menuCategories.count) / 3
                }
                else {
                    cellHeight = 160 * (CGFloat(self.menuCategories.count) / 3 + 1)
                }
                
                return cellHeight
            default:
                return 180
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell_id = ""
        //var table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
        
        switch indexPath.row {
            case 0:
                cell_id = "intro_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! IntroCell
                return table_cell
                
                //break
            case 1:
                cell_id = "search_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                
                let searchTxt = table_cell.viewWithTag(10) as! UITextField
                searchTxt.addTarget(self, action: #selector(self.searchAction(_:)), for: .editingDidEndOnExit)
                
                return table_cell
                
                //break
            
            case 2:
                cell_id = "category_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! CategoryCell
                table_cell.homeVC = self
                table_cell.loadCategories()
                
                return table_cell
            
            case 3:
                cell_id = "order_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! OrderCell
                
                table_cell.homeVC = self
                table_cell.title = "Favorite Choices"
                table_cell.orders = self.menuTopOrders
                table_cell.loadOrders()
                
                return table_cell
                
                //break
            case 4:
                cell_id = "order_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! OrderCell
                
                table_cell.homeVC = self
                table_cell.title = "Based on your likes"
                table_cell.orders = self.menuPrevOrders
                table_cell.loadOrders()
                
                return table_cell
                //break
            
            default:
                cell_id = "search_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                return table_cell
                
                //break
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        AppUtil.user = DrinkUser()
        UserDefaults.standard.removeObject(forKey: "user_login")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_password")
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc func searchAction(_ sender: UITextField) {
        let searchKey = sender.text!
        
        if (searchKey.count > 0) {
            
            sender.text = ""
            
            var menuItems = [] as! [MenuItem]
            
            for category in AppUtil.categories {
                
                if (category.subCategories.count > 0) {
                    
                    for sub in category.subCategories {
                        
                        for item in sub.menuItems {
                            if (item.menuitemName.uppercased().contains(searchKey.uppercased())) {
                                menuItems.append(item)
                            }
                        }
                    }
                }
                else {
                    for item in category.menuItems {
                        if (item.menuitemName.uppercased().contains(searchKey.uppercased())) {
                            menuItems.append(item)
                        }
                    }
                }
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            vc.menuItems = menuItems
            self.present(vc, animated: false, completion: nil)
            
        }
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.preferredContentSize = CGSize(width: 200, height: 360)
        
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        
        popover.permittedArrowDirections = .any
        popover.sourceView = self.view
        popover.sourceRect = self.menuBtn.frame
        popover.delegate = self
        
        vc.homeVC = self
        present(vc, animated: false, completion: nil)
        //self.present(vc, animated: false, completion: nil)
    }
    
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
     
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
     
    }
     
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
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

}
