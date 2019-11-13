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
        self.menuCategories = []
        self.menuTopOrders = []
        self.menuPrevOrders = []
        
        self.loadMenuCategory()
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

                let cellHeight = 160 * CGFloat(self.menuCategories.count) / 3
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
                table_cell.title = "Favorite Choices"
                table_cell.orders = self.menuTopOrders
                table_cell.loadOrders()
                
                return table_cell
                
                //break
            case 4:
                cell_id = "order_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! OrderCell
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
        
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.preferredContentSize = CGSize(width: 240, height: 320)
        
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
