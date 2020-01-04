//
//  CartVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/4/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import PKHUD

class CartVC: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var cartsTable: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var menuBtn: UIButton!
    
    var isSub : Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (self.isSub) {
            self.headerView.isHidden = true
            self.headerHeight.constant = -20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.cartsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (AppUtil.cartsList.count > 0) {
            switch indexPath.row {
                case AppUtil.cartsList.count:
                        return 80
                default:
                    return 44
            }
        }
        else {
            switch indexPath.row {
                case 0:
                    return 240
                case 1:
                    return 80
                default:
                    return 44
            }
        }  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (AppUtil.cartsList.count > 0) {
            return AppUtil.cartsList.count + 1
        }
        else {
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell_id = ""
        
        if (AppUtil.cartsList.count > 0) {
            switch indexPath.row {
                
                case AppUtil.cartsList.count:
                    cell_id = "last_cell"
                    let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                    let btn = table_cell.viewWithTag(10) as! UIButton
                    btn.setTitle("CHECK OUT", for: .normal)
                    btn.addTarget(self, action: #selector(self.goCheckOutAction(_:)), for: .touchUpInside)
                    
                    return table_cell
                default:
                    cell_id = "cart_cell"
                    let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! CartCell
                    table_cell.setMenuItemCell(item: AppUtil.cartsList[indexPath.row])
                    table_cell.tableView = tableView
                    return table_cell
            }
        }
        else {
            switch indexPath.row {
                case 0:
                    cell_id = "empty_cell"
                    let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                    return table_cell
                case 1:
                    cell_id = "last_cell"
                    let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                    let btn = table_cell.viewWithTag(10) as! UIButton
                    btn.setTitle("CONTINUE SHOPPING", for: .normal)
                    
                    btn.addTarget(self, action: #selector(self.goCheckOutAction(_:)), for: .touchUpInside)
                    
                    return table_cell
                default:
                    cell_id = "empty_cell"
                    let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                    return table_cell
            }
        }
        
    }
    
    @objc func goShoppingAction() {
        
    }
    
    @objc func goCheckOutAction(_ sender : UIButton) {
        
        if (sender.titleLabel?.text == "CHECK OUT") {
            
            let url = URL(string: AppUtil.serverURL + "checkout/placeorder")

            var orderedItems = [] as! [[String : Any]]
            
            for item in AppUtil.cartsList {
                let orderedItem = ["choosenSubOptions":[], "clientId": 6, "menuitemCategory": item.menuitemCategory!, "menuitemDescription": item.menuitemDescription!, "menuitemId": item.menuitemId!, "menuitemInfo": item.menuitemInfo!, "menuitemName": item.menuitemName!, "menuitemPhoto": item.menuitemPhoto!, "menuitemPrice": item.menuitemPrice!, "quantity": item.cartsNumber!, "quantityRemaining": 0, "suboptionCategories":[]] as [String : Any]
                orderedItems.append(orderedItem)
            }
            
            let params = ["cartList": orderedItems, "orderType":"DELIVERY", "restaurantId":1] as [String : Any]
            let headers = AppUtil.user.getAuthentification()
            
            HUD.show(.progress)
            Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
                
                HUD.hide()
                guard response.result.isSuccess else {

                    return
                }
                
                let value = response.result.value!
                AppUtil.orderId = value
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
                self.present(vc, animated: false, completion: nil)
            }
            
        }
        else {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        self.isSub = true
        return "Carts"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
